shared_examples_for "object with style" do
  it "merges new styles" do
    old_style = subject.style
    subject.style :left => 100
    subject.style :top => 50
    expect(subject.style).to eq(old_style.merge(:left => 100, :top => 50))
  end

  describe 'changing style' do
    before do
      subject.stub(:change_style)
    end

    it 'calls change_style when the style is changed' do
      subject.style :left => 50
      expect(subject).to have_received(:change_style)
    end

    it 'does not call change_style when style is called without args' do
      subject.style
      expect(subject).not_to have_received(:change_style)
    end
  end
end
