# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Download do
  include_context "dsl app"

  let(:name) { "http://www.google.com/logos/nasa50th.gif" }
  let(:response_body) { "NASA 50th logo" }
  let(:response_status) { ["200", "OK"] }
  let(:response_headers) { { "content-length" => "42" } }
  let(:opts) { {save: "nasa50th.gif"} }

  subject(:download) { Shoes::Download.new app, parent, name, opts, &input_block }

  let(:percent) { download.percent }
  let(:length) { download.length }
  let(:content_length) { download.content_length }

  before do
    expect(app.current_slot).to receive(:create_bound_block).at_least(1) { |blk| blk ? blk : nil }

    stub_request(:get, name)
      .to_return(status: response_status, body: response_body, headers: response_headers)
  end

  after do
    File.delete opts[:save] if File.exist? opts[:save]
  end

  context 'before it has been started' do
    it 'is 0 percent' do
      expect(percent).to eq(0)
    end

    it 'understands abort' do
      expect(download).to respond_to(:abort)
    end

    it 'has initial content_length of 1' do
      expect(content_length).to eq(1)
    end

    it 'has initial length of 1' do
      expect(length).to eq(1)
    end
  end

  context 'without a progress proc' do
    before :each do
      download.start
      download.join_thread
    end

    it 'finishes' do
      expect(download).to be_finished
    end

    it 'starts' do
      expect(download).to be_started
    end

    it 'creates the file specified by save' do
      expect(File.exist?(opts[:save])).to be_truthy
    end
  end

  context 'with a progress proc' do
    let(:progress_proc) { proc {} }
    let(:opts) { {save: "nasa50th.gif", progress: progress_proc} }
    subject(:download) { Shoes::Download.new app, parent, name, opts }

    before :each do
      # Don't let GUI actually block while we're testing
      allow(download.gui).to receive(:busy?).and_return(false)
      allow(download.gui).to receive :eval_block
      download.start
      download.join_thread
    end

    context 'with content length' do
      it 'calls the progress proc from start, download and finish' do
        expect(download.gui).to have_received(:eval_block)
          .with(progress_proc, download)
          .exactly(3).times
      end
    end

    context 'without content length' do
      let(:response_headers) { {} }

      it 'does not call on progress, but called from content length and finish' do
        expect(download.gui).to have_received(:eval_block)
          .with(progress_proc, download)
          .twice
      end

      it 'can call percent just fine thanks' do
        expect(download.percent).to eq(0)
      end
    end
  end

  describe 'after it is finished' do
    let(:result) { download }
    let(:response) { download.response }

    before :each do
      allow(download.gui).to receive(:eval_block)
      download.start
      download.join_thread
    end

    context 'with a block' do
      it 'calls the block with a result' do
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
      let(:finish_proc) { proc {} }
      let(:opts) { {save: "nasa50th.gif", finish: finish_proc} }
      subject(:download) { Shoes::Download.new app, parent, name, opts }

      it 'calls the finish proc' do
        expect(download.gui).to have_received(:eval_block).with(finish_proc, subject)
      end
    end
  end

  describe 'when things go wrong' do
    it 'reports back to the parent thread' do
      error = StandardError.new("Nope")

      expect(download.gui).to receive(:eval_block).with(anything, error)
      allow(download).to receive(:open).and_raise(error)

      download.start
      download.join_thread
    end

    it 'reports empty values for the response' do
      error = StandardError.new("Nope")
      allow(download).to receive(:download_started).and_raise(error)

      download.start
      download.join_thread

      expect(download.response.body).to be_empty
      expect(download.response.headers).to be_empty
      expect(download.response.status).to be_empty
    end

    it 'does not die on socket errors, but logs them' do
      error = SocketError.new('Badumz')

      expect(download.gui).not_to receive(:eval_block)
      expect(Shoes.logger).to receive(:error).with error
      allow(download).to receive(:open).and_raise(error)

      download.start
      download.join_thread
    end

    describe 'with custom error blocks' do
      let(:error_proc) { proc {} }
      let(:opts) { {save: "nasa50th.gif", error: error_proc} }

      it 'gets called' do
        error = StandardError.new("Nope")

        expect(download.gui).to receive(:eval_block).with(error_proc, error)
        allow(download).to receive(:open).and_raise(error)

        download.start
        download.join_thread
      end
    end
  end
end
