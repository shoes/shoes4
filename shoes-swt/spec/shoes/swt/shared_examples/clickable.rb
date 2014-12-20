shared_examples 'clickable backend' do
  let(:click_listener) {
    double("listener", add_click_listener: nil, add_release_listener: nil)
  }

  before do
    allow(swt_app).to receive(:click_listener) { click_listener }
  end

  describe 'interaction with the swt app object' do
    it 'adds a listener for the MouseDown event when click is called' do
      subject.click Proc.new {}
      expect(click_listener).to have_received(:add_click_listener).at_least(1)
    end

    it 'adds a listener for the MouseUp event when release is called' do
      subject.release Proc.new {}
      expect(click_listener).to have_received(:add_release_listener).at_least(1)
    end
  end
end
