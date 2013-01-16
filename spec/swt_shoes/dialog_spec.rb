require 'swt_shoes/spec_helper'

main_object = self

describe Shoes::Swt::Dialog do

  def mock_message_box
    create_mock_message_box mock(:mb, open: true, :message= => true)
  end

  def mock_message_box_expecting_message(message)
    mock_dialog = mock(:mb, open: true)
    mock_dialog.should_receive(:message=).with(message)
    create_mock_message_box mock_dialog
  end

  def mock_message_box_returning(return_value)
    create_mock_message_box mock(:mb, :message= => true, open: return_value)
  end

  def create_mock_message_box(mock_dialog)
    ::Swt::Widgets::Shell.stub(:new)
    ::Swt::Widgets::MessageBox.stub(new: mock_dialog)
  end

  before :each do
    @dialog = Shoes::Swt::Dialog.new
  end

  TEXT = 'some random text'

  describe 'alert' do
    it 'pops up a window containing a short message.' do
      mock_message_box_expecting_message TEXT
      @dialog.alert TEXT
    end

    it 'returns nil' do
      mock_message_box
      @dialog.alert('Nothing').should be_nil
    end
  end

  describe 'confirm' do
    it 'pops up a window containing a short message.' do
      mock_message_box_expecting_message TEXT
      @dialog.confirm TEXT
    end

    it 'is true when YES was pressed' do
      mock_message_box_returning ::Swt::SWT::YES
      subject.confirm.should be_true
    end

    it 'is false when NO was pressed' do
      mock_message_box_returning ::Swt::SWT::NO
      subject.confirm.should be_false
    end

    it 'is false when an arbitary number is returned' do
      mock_message_box_returning 42
      subject.confirm.should be_false
    end
  end

  describe 'dialog_chooser' do
    it 'responds to it' do
      @dialog.should respond_to :dialog_chooser
    end
  end

  describe 'on the main object' do
    describe '#alert' do

      it 'returns nil' do
        mock_message_box
        main_object.alert('Something').should be_nil
      end
    end

    describe '#confirm' do
      it 'returns true when YES was clicked' do
        mock_message_box_returning ::Swt::SWT::YES
        main_object.confirm('1 + 1 = 2').should be_true
      end

      it 'returns false when NO was clicked' do
        mock_message_box_returning ::Swt::SWT::NO
        main_object.confirm('1 + 1 = 3').should be_false
      end
    end
  end

end
