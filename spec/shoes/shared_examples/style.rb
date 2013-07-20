shared_examples_for "object with style" do
  it "merges new styles" do
    old_style = subject.style
    subject.style :left => 100
    subject.style :top => 50
    subject.style.should eq(old_style.merge(:left => 100, :top => 50))
  end

  it 'only calls change_style when the style is changed' do
    subject.should_receive :change_style
    subject.style :left => 50
  end

  it 'does nto call change_style when style is called without args' do
    subject.should_not_receive :change_style
    subject.style
  end
end

