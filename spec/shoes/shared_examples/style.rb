shared_examples_for "object with style" do
  it "merges new styles" do
    old_style = subject.style
    subject.style :left => 100
    subject.style :top => 50
    expect(subject.style).to eq(old_style.merge(:left => 100, :top => 50))
  end

  describe 'changing style' do
    before do
      allow(subject).to receive(:update_style)
    end

    it 'calls change_style when the style is changed' do
      subject.style :left => 50
      expect(subject).to have_received(:update_style)
    end

    it 'does not call change_style when style is called without args' do
      subject.style
      expect(subject).not_to have_received(:update_style)
    end
  end
end

all_the_styles = %w[align angle attach autoplay bottom cap center change checked choose
                    click curve displace_left displace_top emphasis family fill font
                    group height hidden inner items justify kerning leading left margin
                    margin_bottom margin_left margin_right margin_top outer points radius
                    right rise rotate scroll secret size state stretch strikecolor strikethrough 
                    stroke strokewidth text top undercolor underline variant weight width
                    wrap]


all_the_styles.map(&:to_sym).each do |style|
  shared_examples_for "object that styles with #{style}" do

    it "has #{style} setter" do
      expect(subject).to respond_to("#{style}=".to_sym)
    end

    it "has #{style} getter" do
      expect(subject).to respond_to(style)
    end

  end
end
