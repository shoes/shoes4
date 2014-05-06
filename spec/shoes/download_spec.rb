require 'shoes/spec_helper'
require 'webmock/rspec'

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
    download.join_thread
    File.delete opts[:save]
  end

  it "finishes" do
    eventually { expect(download).to be_finished }
  end

  it 'starts' do
    eventually { expect(download).to be_started }
  end

  it 'understands percent' do
    eventually{ expect(percent).to eql(0)}
  end

  it 'understands abort' do
    expect(download).to respond_to(:abort)
  end

  it "understands content_length" do
    expect(content_length).to eql(1)
  end

  it "understands length" do
    expect(length).to eql(1)
  end

  it 'creates the file specified by save' do
    download
    eventually { expect(File.exist?(opts[:save])).to be_true }
  end

  context 'with a progress proc' do
    let(:progress_proc) {Proc.new {}}
    let(:opts) { {save: "nasa50th.gif", progress: progress_proc} }
    subject(:download) { Shoes::Download.new app, parent, name, opts}

    it 'calls the progress proc from start, download and finish' do
      eventually {
        expect(download.gui).to receive(:eval_block).
                                  with(progress_proc, download).
                                  exactly(3).times
      }
    end

    context 'without content length' do
      before do
        stub_request(:get, name)
          .to_return(:headers => {}, :status => response_status, :body => response_body)
      end

      it 'does not fail on progress, but called from content length and finish' do
        pending 'Sometimes fails on Travis'
        eventually {
          expect(download.gui).to receive(:eval_block).
          with(progress_proc, download).
          twice
        }
      end
    end
  end

  describe 'after it is finished' do
    let(:result) {download}
    let(:response) {download.response}

    context 'with a block' do

      it 'calls the block with a result' do
        eventually { expect(download.gui).to receive(:eval_block).with(input_block, result) }
      end

      describe 'response object' do
        it 'has headers hash' do
          eventually { expect(response.headers).to eql(response_headers)}
        end

        it 'has body text' do
          eventually { expect(response.body).to eql(response_body)}
        end

        it 'has status array' do
          eventually { expect(response.status).to eql(response_status)}
        end
      end
    end

    context 'without a block' do
      subject(:download) { Shoes::Download.new app, parent, name, opts }

      it 'does not call the block' do
        expect(download.gui).not_to receive(:eval_block)
      end
    end

    context 'with a finish proc' do
      let(:finish_proc) {Proc.new {}}
      let(:opts) { {save: "nasa50th.gif", finish: finish_proc} }
      subject(:download) { Shoes::Download.new app, parent, name, opts}

      it 'calls the finish proc' do
        pending 'Another Travis failure...'
        eventually { expect(download.gui).to receive(:eval_block).with(finish_proc, result) }
      end
    end

  end
end
