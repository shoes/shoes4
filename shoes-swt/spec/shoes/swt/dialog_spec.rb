require 'shoes/swt/spec_helper'

main_object = self

describe Shoes::Swt::Dialog do

  def double_message_box
    create_double_message_box double(:mb, open: true, :message= => true)
  end

  def double_message_box_expecting_message(message)
    double_dialog = double(:mb, open: true)
    expect(double_dialog).to receive(:message=).with(message)
    create_double_message_box double_dialog
  end

  def double_message_box_returning(return_value)
    create_double_message_box double(:mb, :message= => true, open: return_value)
  end

  def create_double_message_box(double_dialog)
    allow(::Swt::Widgets::Shell).to receive(:new)
    allow(::Swt::Widgets::MessageBox).to receive_messages(new: double_dialog)
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
      expect(@dialog.alert('Nothing')).to be_nil
    end
  end

  describe 'confirm' do
    it 'pops up a window containing a short message.' do
      double_message_box_expecting_message TEXT
      @dialog.confirm TEXT
    end

    it 'is true when YES was pressed' do
      double_message_box_returning ::Swt::SWT::YES
      expect(subject.confirm).to be_truthy
    end

    it 'is false when NO was pressed' do
      double_message_box_returning ::Swt::SWT::NO
      expect(subject.confirm).to be_falsey
    end

    it 'is false when an arbitary number is returned' do
      double_message_box_returning 42
      expect(subject.confirm).to be_falsey
    end
  end

  describe 'dialog_chooser' do
    it 'responds to it' do
      expect(@dialog).to respond_to :dialog_chooser
    end
  end

  describe 'ask_color' do
    it 'responds to it' do
      expect(@dialog).to respond_to :ask_color
    end
  end

  describe 'on the main object' do
    describe '#alert' do

      it 'returns nil' do
        double_message_box
        expect(main_object.alert('Something')).to be_nil
      end
    end

    describe '#confirm' do
      it 'returns true when YES was clicked' do
        double_message_box_returning ::Swt::SWT::YES
        expect(main_object.confirm('1 + 1 = 2')).to be_truthy
      end

      it 'returns false when NO was clicked' do
        double_message_box_returning ::Swt::SWT::NO
        expect(main_object.confirm('1 + 1 = 3')).to be_falsey
      end
    end
  end

end
