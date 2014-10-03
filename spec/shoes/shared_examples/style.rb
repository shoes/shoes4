shared_examples_for "object with style" do

  def uses_app_default?(key)
    if defined? self.class::STYLES
      subject.style[key] && !subject.class::STYLES[key]
    else
      subject.style[key]
    end
  end

  describe 'using app-level styles' do
    
    it 'initially uses app defaults' do
      app.style.each do |key, value|
        expect(subject.style[key]).to eq(value) if uses_app_default? key
      end
    end

    it 'overwrites app defaults' do
      subject.style(fill: '#fff')
      expect(subject.style[:fill]).not_to eq(app.style[:fill])
    end
  end

  describe 'using element-level styles' do
    let(:arg_styles) { {jellybean: 'blueberry'} }

    it 'uses element defaults' do
      user_facing_app.style(subject.class, jellybean: 'pumpkin')
      expect(subject_without_style.style[:jellybean]).to eq('pumpkin')
    end

    it 'overwrites element defaults' do
      user_facing_app.style(subject.class, jellybean: 'pumpkin')
      expect(subject_with_style.style[:jellybean]).to eq('blueberry')
    end
  end

  describe 'using the style method' do

    it "merges new styles" do
      old_style = subject.style
      subject.style(left: 100, top: 50)
      expect(subject.style).to eq(old_style.merge(left: 100, top: 50))
    end

    it 'calls update_style when the style is changed' do
      allow(subject).to receive(:update_style)
      subject.style left: 50
      expect(subject).to have_received(:update_style)
    end

    it 'does not call update_style when style is called without args' do
      allow(subject).to receive(:update_style)
      subject.style
      expect(subject).not_to have_received(:update_style)
    end

    it 'does not call update_style when style is unchanged' do
      allow(subject).to receive(:update_style)
      old_left = subject.style[:left]
      subject.style(left: old_left)
      expect(subject).not_to have_received(:update_style)
    end
  end

  describe 'using setters and getters' do

    it 'has a style setter for all styles' do
      subject.supported_styles.each do |style|
        expect(subject).to respond_to("#{style}=".to_sym)
      end
    end

    it 'has a style getter for all styles' do
      subject.supported_styles.each do |style|
        expect(subject).to respond_to("#{style}".to_sym)
      end
    end
  end

end
