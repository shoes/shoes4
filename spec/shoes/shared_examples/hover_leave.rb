shared_examples "hover and leave events" do
  it { should respond_to :hover }
  it { should respond_to :leave }
end
