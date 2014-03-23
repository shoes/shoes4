shared_examples_for "background DSL method" do
  context "with a valid hex string" do
    it "sets color" do
      background = subject.background("#fff")
      expect(background.fill).to eq(Shoes::COLORS[:white])
    end
  end

  context "with an invalid hex string" do
    it 'raises an argument error' do
      expect{ subject.background('#ffq') }.to raise_error('Bad hex color: #ffq')
    end
  end

  context 'with no valid image' do
    it 'ignores the background' do
      expect{ subject.background('fake-shoes.jpg') }.not_to raise_error
    end
  end

  context 'with a valid image' do
    it 'creates a Shoes::Background' do
      expect(subject.background('static/shoes-icon.png')).to be_an_instance_of(Shoes::Background)
    end
  end
end
