require 'shoes/spec_helper'

describe Shoes::Download do
  include AsyncHelper
  include_context "dsl app"

  let(:name) { "http://www.google.com/logos/nasa50th.gif" }
  let(:response_body) { "NASA 50th logo" }
  let(:response_status) {["200", "OK"]}
  let(:response_headers) { { "content-length" => "42" }}
  let(:opts) { {save: "nasa50th.gif"} }
  subject(:download) { Shoes::Download.new app, parent, name, opts, &input_block }

  let(:percent) {download.percent}
  let(:length) {download.length}
  let(:content_length) {download.content_length}

  before do
    stub_request(:get, name)
      .to_return(:status => response_status, :body => response_body, :headers => response_headers)
  end

  after do
    File.delete opts[:save] if File.exist? opts[:save]
  end

  context 'before it has been started' do
    it 'understands percent' do
      eventually{ expect(percent).to eql(0)}
    end

    it 'understands abort' do
      expect(download).to respond_to(:abort)
    end

    it 'understands content_length' do
      expect(content_length).to be >= 1
    end

    it 'understands length' do
      expect(length).to be >= 1
    end
  end

  context 'without a progress proc' do
    before :each do
      download.start
    end

    it 'finishes' do
      eventually { expect(download).to be_finished }
    end

    it 'starts' do
      eventually { expect(download).to be_started }
    end

    it 'creates the file specified by save' do
      eventually { expect(File.exist?(opts[:save])).to be_truthy }
    end
  end

  context 'with a progress proc' do
    let(:progress_proc) {Proc.new {}}
    let(:opts) { {save: "nasa50th.gif", progress: progress_proc} }
    subject(:download) { Shoes::Download.new app, parent, name, opts}

    before :each do
      allow(download.gui).to receive :eval_block
      download.start
      download.join_thread
    end

    context 'with content length' do
      it 'calls the progress proc from start, download and finish' do
        expect(download.gui).to have_received(:eval_block).
                                  with(progress_proc, download).
                                  exactly(3).times
      end
    end

    context 'without content length' do
      let(:response_headers) { Hash.new }

      it 'does not call on progress, but called from content length and finish' do
        expect(download.gui).to have_received(:eval_block).
          with(progress_proc, download).
          twice
      end
    end
  end

  describe 'after it is finished' do
    let(:result) {download}
    let(:response) {download.response}

    before :each do
      allow(download.gui).to receive(:eval_block)
      download.start
      download.join_thread
    end

    context 'with a block' do

      it 'calls the block with a result' do
        #skip 'damn you download specs we really need to you to be reliable'
        # https://travis-ci.org/shoes/shoes4/jobs/25269033
        expect(download.gui).to have_received(:eval_block).with(input_block, result)
      end

      describe 'response object' do
        it 'has headers hash' do
          expect(response.headers).to eql(response_headers)
        end

        it 'has body text' do
          expect(response.body).to eql(response_body)
        end

        it 'has status array' do
          expect(response.status).to eql(response_status)
        end
      end
    end

    context 'without a block' do
      subject(:download) { Shoes::Download.new app, parent, name, opts }

      it 'does not call the block' do
        expect(download.gui).not_to have_received(:eval_block)
      end
    end

    context 'with a finish proc' do
      let(:finish_proc) {Proc.new {}}
      let(:opts) { {save: "nasa50th.gif", finish: finish_proc} }
      subject(:download) { Shoes::Download.new app, parent, name, opts}

      it 'calls the finish proc' do
        #skip 'Another Travis failure...'
        expect(download.gui).to have_received(:eval_block).with(finish_proc, result)
      end
    end

  end
end
