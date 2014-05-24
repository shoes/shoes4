shared_examples 'clickable backend' do

  before :each do
    swt_app.stub :add_clickable_element
    dsl.stub(:in_bounds?) { true }
  end

  let(:clickable_block) {double 'clickable_block'}
  let(:clickable_subject) do
    subject.clickable clickable_block
    subject
  end

  let(:mouse_event) {double 'mouse_event', button: 1, x: 2, y:3}

  it {should respond_to :clickable}
 
  it 'its click_handler should not be nil' do
    clickable_subject.click_listener.should_not be_nil
  end

  it 'calls the block when a click event comes in bounds' do
    clickable_block.should_receive(:call).with(1, 2, 3)
    clickable_subject.click_listener.handleEvent mouse_event
  end

  describe 'interaction with the swt app object' do

    def expect_adds_listener_for(event)
      swt_app.should_receive(:add_listener).with(event, clickable_subject.click_listener)
    end

    it 'receives the add_clickable_element message' do
      swt_app.should_receive(:add_clickable_element)
      clickable_subject
    end

    it 'adds a listener for the MouseDown event' do
      expect_adds_listener_for ::Swt::SWT::MouseDown
      clickable_subject
    end

    it 'adds a listener for the MouseDown event when click is called' do
      expect_adds_listener_for ::Swt::SWT::MouseDown
      subject.click do ; end
    end

    it 'adds a listener for the MouseUp event when release is called' do
      expect_adds_listener_for ::Swt::SWT::MouseUp
      subject.release do ; end
    end
  end

  it 'only hands the dsl object to the app' do
    subject.click do ; end
    # at least is used for link - because it already triggers it in intialize
    expect(swt_app).to have_received(:add_clickable_element).with(subject.dsl).
                           at_least(1).times
  end
end
