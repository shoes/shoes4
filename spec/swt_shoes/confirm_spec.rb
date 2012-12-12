require 'swt_shoes/spec_helper'

def create_mock_message_box_returning(return_value)
  ::Swt::Widgets::Shell.stub(:new)
  mock_message_box = mock(:mb, :message= => true, open: return_value)
  ::Swt::Widgets::MessageBox.stub(:new) { mock_message_box }
end

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

  describe '#confirmed' do
    it 'is true when YES was pressed' do
      create_mock_message_box_returning ::Swt::SWT::YES
      subject.should be_confirmed
    end

    it 'is false when NO was pressed' do
      create_mock_message_box_returning ::Swt::SWT::NO
      subject.should_not be_confirmed
    end

    it 'is false when an arbitary number is returned' do
      create_mock_message_box_returning 42
      subject.should_not be_confirmed
    end
  end

  describe 'confirm method on the main object' do
    it 'is known of by the main object' do
      main_object.respond_to?(:confirm).should be true
    end

    it 'returns true when YES was clicked' do
      create_mock_message_box_returning ::Swt::SWT::YES
      main_object.confirm('1 + 1 = 2').should be_true
    end

    it 'returns false when NO was clicked' do
      create_mock_message_box_returning ::Swt::SWT::NO
      main_object.confirm('1 + 1 = 3').should be_false
    end
  end

end
