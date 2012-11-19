shared_examples_for "an swt pattern" do
  it { should respond_to(:apply_as_stroke) }
  it { should respond_to(:apply_as_fill) }
end
