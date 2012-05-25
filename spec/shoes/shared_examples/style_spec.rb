shared_examples_for "object with style" do
  it "merges new styles" do
    old_style = subject.style
    subject.style :left => 100
    subject.style :top => 50
    subject.style.should eq(old_style.merge(:left => 100, :top => 50))
  end
end

