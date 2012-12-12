require 'swt_shoes/spec_helper'

main_object = self

describe Shoes::Swt::Alert do

  before :each do
    ::Swt::Widgets::Shell.stub(:new)
  end

  TEXT = 'some random text'

  let(:dsl) { double('dsl') }
  let(:parent) { double('parent') }

  subject { Shoes::Swt::Alert.new dsl, parent, TEXT }
  
  it "pops up a window containing a short message." do
    mock_message_box = mock(:mb, open: true)
    mock_message_box.should_receive(:message=).with(TEXT)
    ::Swt::Widgets::MessageBox.stub(:new) { mock_message_box }
    subject
  end

  it 'is known of by the main object' do
    main_object.respond_to?(:alert).should be true
  end

end
