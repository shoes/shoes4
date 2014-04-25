require 'shoes/spec_helper'
require 'webmock/rspec'

describe Shoes::Download do
  include AsyncHelper
  include_context "dsl app"

  let(:name) { "http://www.google.com/logos/nasa50th.gif" }
  let(:response_body) { "NASA 50th logo" }
  let(:opts) { {save: "nasa50th.gif"} }
  subject(:download) { Shoes::Download.new app, parent, name, opts, &input_block }

  before do
    stub_request(:get, name)
      .to_return(:status => 200, :body => response_body, :headers => {})
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
    expect(download).to respond_to{:percent}
  end

  it 'understands abort' do
    expect(download).to respond_to{:abort}
  end

  it "understands length and content_length and they're the same" do
    expect(download.content_length).to eql(download.length)
  end

  it 'creates the file specified by save' do
    download
    eventually { expect(File.exist?(opts[:save])).to be_true }
  end

  describe 'after it is finished' do
    let(:result) {download}
    let(:response) {download.response}

    context 'with a block' do

      it 'calls the block with a result' do
        eventually { expect(download.gui).to receive(:eval_block).with(input_block, result) }
      end

      it 'creates an HttpResponse' do
        eventually{expect(response).to be_an_instance_of(Shoes::HttpResponse)}
      end

      describe 'HttpResponse object' do
        it 'has headers hash' do
          eventually { expect(response.headers).to be_an_instance_of(Hash)}
        end
        
        it 'has body text' do
          eventually { expect(response.body).to be_an_instance_of(String)}
        end

        it 'has status array' do
          eventually { expect(response.status).to be_an_instance_of(Array)}
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
        eventually { expect(download.gui).to receive(:eval_block).with(finish_proc, result) }
      end
    end

  end
end
