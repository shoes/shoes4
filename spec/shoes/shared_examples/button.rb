shared_examples "checkable" do
  it { should respond_to :checked= }
  it { should respond_to :checked? }
  it { should respond_to :focus }
end
