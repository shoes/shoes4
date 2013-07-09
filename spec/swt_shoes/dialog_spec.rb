require 'swt_shoes/spec_helper'

main_object = self

describe Shoes::Swt::Dialog do

  def double_message_box
    create_double_message_box double(:mb, open: true, :message= => true)
  end

  def double_message_box_expecting_message(message)
    double_dialog = double(:mb, open: true)
    double_dialog.should_receive(:message=).with(message)
    create_double_message_box double_dialog
  end

  def double_message_box_returning(return_value)
    create_double_message_box double(:mb, :message= => true, open: return_value)
  end

  def create_double_message_box(double_dialog)
    ::Swt::Widgets::Shell.stub(:new)
    ::Swt::Widgets::MessageBox.stub(new: double_dialog)
  end

  before :each do
    @dialog = Shoes::Swt::Dialog.new
  end

  TEXT = 'some random text'

  describe 'alert' do
    it 'pops up a window containing a short message.' do
      double_message_box_expecting_message TEXT
      @dialog.alert TEXT
    end

    it 'returns nil' do
      double_message_box
      @dialog.alert('Nothing').should be_nil
    end
  end

  describe 'confirm' do
    it 'pops up a window containing a short message.' do
      double_message_box_expecting_message TEXT
      @dialog.confirm TEXT
    end

    it 'is true when YES was pressed' do
      double_message_box_returning ::Swt::SWT::YES
      subject.confirm.should be_true
    end

    it 'is false when NO was pressed' do
      double_message_box_returning ::Swt::SWT::NO
      subject.confirm.should be_false
    end

    it 'is false when an arbitary number is returned' do
      double_message_box_returning 42
      subject.confirm.should be_false
    end
  end

  describe 'dialog_chooser' do
    it 'responds to it' do
      @dialog.should respond_to :dialog_chooser
    end
  end

  describe 'ask' do
    it 'responds to it' do
      @dialog.should respond_to :ask
    end
  end

  describe 'ask_color' do
    it 'responds to it' do
      @dialog.should respond_to :ask_color
    end
  end

  describe 'on the main object' do
    describe '#alert' do

      it 'returns nil' do
        double_message_box
        main_object.alert('Something').should be_nil
      end
    end

    describe '#confirm' do
      it 'returns true when YES was clicked' do
        double_message_box_returning ::Swt::SWT::YES
        main_object.confirm('1 + 1 = 2').should be_true
      end

      it 'returns false when NO was clicked' do
        double_message_box_returning ::Swt::SWT::NO
        main_object.confirm('1 + 1 = 3').should be_false
      end
    end
  end

end
