require 'shoes/spec_helper'
require 'webmock/rspec'

describe Shoes::Download do
  include AsyncHelper
  include_context "dsl app"

  let(:name) { "http://www.google.com/logos/nasa50th.gif" }
  let(:response_body) { "NASA 50th logo" }
  let(:args) { {:save => "nasa50th.gif"} }
  subject(:download) { Shoes::Download.new app, parent, name, args, &input_block }

  before do
    stub_request(:get, name)
      .to_return(:status => 200, :body => response_body, :headers => {})
  end

  after do
    download.join_thread
    File.delete args[:save]
  end

  it "finishes" do
    eventually { expect(download).to be_finished }
  end

  it 'starts' do
    eventually { expect(download).to be_started }
  end

  it 'creates the file specified by save' do
    download
    eventually { expect(File.exist?(args[:save])).to be_true }
  end

  describe 'after it is finished' do
    let(:result) {download}

    context 'with a block' do
      it 'calls the block with a result' do
        eventually do
          expect(download.gui).to receive(:eval_block).with(input_block, result)
        end
      end
    end

    context 'without a block' do
      subject(:download) { Shoes::Download.new app, parent, name, args }

      it 'does not call the block' do
        expect(download.gui).not_to receive(:eval_block)
      end
    end
  end
end
