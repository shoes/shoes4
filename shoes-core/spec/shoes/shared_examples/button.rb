shared_examples "checkable" do
  it { is_expected.to respond_to :checked= }
  it { is_expected.to respond_to :checked? }
  it { is_expected.to respond_to :focus }
  it { is_expected.to respond_to :click }
end
