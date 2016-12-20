shared_examples "clickable object" do
  it { is_expected.to respond_to :click }
  it { is_expected.to respond_to :release }
  it { is_expected.to respond_to :register_click }

  it "can chain click" do
    result = subject.click do
    end

    expect(result).to eq(subject)
  end

  it "can chain release" do
    result = subject.release do
    end

    expect(result).to eq(subject)
  end
end
