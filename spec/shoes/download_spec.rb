require 'shoes/spec_helper'
VCR.use_cassette 'download' do
  describe Shoes::Download do
    # makes it run offline
    let(:app) { Shoes::App.new }
    let(:block) { proc{} }
    let(:name) { "http://www.google.com/logos/nasa50th.gif" }
    let(:args) { {:save => "nasa50th.gif"} }
    subject{ Shoes::Download.new app, name, args, &block }

    after do
      subject.join_thread
      File.delete args[:save]
    end

    # TODO: use vcr gem, finally to make it run wihtout Internet :-D
    it "should have started? and finished? methods" do
      subject.should respond_to :started?
      subject.should respond_to :finished?
    end
  end
end