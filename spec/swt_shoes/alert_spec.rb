require 'swt_shoes/spec_helper'

main_object = self

describe Shoes::Swt::Alert do

  def create_mock_message_box
    mock_message_box = mock(:mb, open: true, :message= => true)
    ::Swt::Widgets::MessageBox.stub(:new => mock_message_box)
    end

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

  describe 'on the main object' do
    it 'is known of by the main object' do
      main_object.respond_to?(:alert).should be true
    end

    it 'returns nil' do
      create_mock_message_box
      main_object.alert('Something').should be_nil
    end
  end

end
