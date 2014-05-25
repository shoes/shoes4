shared_examples "clickable object" do
  it { should respond_to :click }
  it { should respond_to :release }
  it { should respond_to :clickable_options }
end
