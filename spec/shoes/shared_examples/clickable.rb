shared_examples "clickable object" do
  it { is_expected.to respond_to :click }
  it { is_expected.to respond_to :release }
  it { is_expected.to respond_to :register_click }
end
