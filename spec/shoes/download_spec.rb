require 'shoes/spec_helper'

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

  it "should have started? and finished? methods" do
    VCR.use_cassette 'download' do
      extend AsyncHelper
      eventually(timeout: 10, interval: 1) {subject.should be_finished}
    end
  end
end
