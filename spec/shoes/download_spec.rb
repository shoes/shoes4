require 'shoes/spec_helper'

describe Shoes::Download do
  # makes it run offline
  let(:app) { Shoes::App.new }
  let(:parent) { app }
  let(:block) { proc{} }
  let(:name) { "http://www.google.com/logos/nasa50th.gif" }
  let(:args) { {:save => "nasa50th.gif"} }
  subject{ Shoes::Download.new app, parent, name, args, &block }

  after do
    subject.join_thread
    File.delete args[:save]
  end

  it "should eventually finish" do
    extend AsyncHelper
    VCR.use_cassette 'download' do
      eventually(timeout: 10, interval: 1) {subject.should be_finished}
    end
  end

  it 'should eventually start' do
    extend AsyncHelper
    VCR.use_cassette 'download' do
      eventually(timeout: 10, interval: 1) {subject.should be_started}
    end
  end

  it 'creates the file specified by save' do
    extend AsyncHelper
    VCR.use_cassette 'download' do
      subject
      eventually(timeout: 10, interval: 1) do
        File.exist?(args[:save]).should be_true
      end
    end
  end

  describe 'with a called block' do
    let(:block) {proc {}}

    it 'calls the block with a result when the download is finished' do
      extend AsyncHelper
      VCR.use_cassette 'download' do
        subject
        eventually(timeout: 10, interval: 1) do
          subject.gui.should_receive :eval_block
        end
      end
    end
  end

end
