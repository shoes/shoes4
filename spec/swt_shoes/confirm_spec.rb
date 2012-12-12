require 'swt_shoes/spec_helper'

main_object = self

describe Shoes::Swt::Confirm do

  TEXT = 'some random text'

  let(:dsl) { double('dsl') }
  let(:parent) { double('parent') }

  subject { Shoes::Swt::Confirm.new dsl, parent, TEXT }

  it "pops up a window containing a short message." do
    ::Swt::Widgets::Shell.stub(:new)
    mock_message_box = mock(:mb, open: true)
    mock_message_box.should_receive(:message=).with(TEXT)
    ::Swt::Widgets::MessageBox.stub(:new) { mock_message_box }
    subject
  end

  it 'is known of by the main object' do
    main_object.respond_to?(:confirm).should be true
  end

end
