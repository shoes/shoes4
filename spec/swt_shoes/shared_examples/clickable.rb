shared_examples 'clickable backend' do

  before :each do
    allow(swt_app).to receive :add_clickable_element
    allow(swt_app).to receive :remove_listener
    allow(swt_app).to receive(:clickable_elements).and_return(clickable_elements)
    allow(dsl).to receive(:in_bounds?) { true }
  end

  let(:block) {clickable_block}
  let(:clickable_elements) { double("clickable_elements", delete: nil) }

  let(:clickable_block) {double 'clickable_block'}
  let(:clickable_subject) do
    subject.clickable clickable_block
    subject
  end

  let(:mouse_event) {double 'mouse_event', button: 1, x: 2, y:3}

  it {is_expected.to respond_to :clickable}

  it 'its click_handler should not be nil' do
    expect(clickable_subject.click_listener).not_to be_nil
  end

  it 'calls the block when a click event comes in bounds' do
    expect(clickable_block).to receive(:call).with(1, 2, 3)
    clickable_subject.click_listener.handleEvent mouse_event
  end

  describe 'interaction with the swt app object' do

    def expect_added_listener_for(event)
      click_listener = subject.click_listener
      expect(swt_app).to have_received(:add_listener).with(event,
                                                           click_listener)
    end

    it 'receives the add_clickable_element message' do
      expect(swt_app).to receive(:add_clickable_element)
      clickable_subject
    end

    it 'adds a listener for the MouseDown event' do
      clickable_subject
      expect_added_listener_for ::Swt::SWT::MouseDown
    end

    it 'adds the correct listener' do
      clickable_subject
      expect_added_listener_for ::Swt::SWT::MouseDown
    end

    it 'adds a listener for the MouseDown event when click is called' do
      subject.click Proc.new {}
      expect_added_listener_for ::Swt::SWT::MouseDown
    end

    it 'adds a listener for the MouseUp event when release is called' do
      subject.release Proc.new {}
      expect_added_listener_for ::Swt::SWT::MouseUp
    end
  end

  it 'only hands the dsl object to the app' do
    subject.click Proc.new {}
    # at least is used for link - because it already triggers it in intialize
    expect(swt_app).to have_received(:add_clickable_element).with(subject.dsl).
                           at_least(1).times
  end
end
