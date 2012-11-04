require 'swt_shoes/spec_helper'

describe "alert" do

  TEXT = 'some random text'

  before :each do
    Shoes::Swt.unregister_all
  end

  let(:dsl) { double('dsl', :text => TEXT) }
  let(:parent) { double('parent') }

  subject { Shoes::Swt::Alert.new dsl, parent, TEXT }
  
  it "pops up a window containing a short message." do
    ::Swt::Widgets::Shell.stub(:new)
    mock_message_box = mock(:mb, open: true)
    mock_message_box.should_receive(:message=).with(TEXT)
    ::Swt::Widgets::MessageBox.stub(:new) { mock_message_box }
    subject
  end
end
