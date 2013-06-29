shared_examples 'clickable backend' do

  before :each do
    subject.stub dsl: click_dsl
  end

  let(:click_dsl) {double 'dsl', app: click_dsl_app, in_bounds?: true}
  let(:click_dsl_app) {double 'dsl_app', gui: click_swt_app}
  let(:click_swt_app) {double 'swt_app', real: click_real,
                              add_clickable_element: true}
  let(:click_real) {double 'real', addListener: true}

  it {should respond_to :clickable}
  let(:clickable_block) {mock 'clickable_block'}
  let(:clickable_subject) do
    subject.clickable clickable_block
    subject
  end

  let(:mouse_event) {stub 'mouse_event', button: 1, x: 2, y:3}

  it 'its click_handler should not be nil' do
    clickable_subject.click_listener.should_not be_nil
  end

  it 'calls the block when a click event comes in bounds' do
    clickable_block.should_receive(:call).with(1, 2, 3)
    clickable_subject.click_listener.handleEvent mouse_event
  end

  describe 'interaction with the app gui' do

    def expect_adds_listener_for(event)
      click_real.should_receive(:addListener).with(event, clickable_subject.click_listener)
    end

    it 'receives the add_clickable_element message' do
      click_swt_app.should_receive(:add_clickable_element)
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

end