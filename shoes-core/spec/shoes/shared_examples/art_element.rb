# frozen_string_literal: true
shared_examples "an art element" do
  it_behaves_like "object with dimensions"
  it_behaves_like "object with parent"

  it_behaves_like "movable object"
  it_behaves_like "clickable object"

  it_behaves_like "object with fill"
  it_behaves_like "object with hover"
  it_behaves_like "object with rotate"
  it_behaves_like "object with stroke"
  it_behaves_like "object with translate"

  # requires we define subject subject_without_style and subject_with_style
  # inside the example block!
  it_behaves_like "object with style"

  it "is painted" do
    expect(subject.painted?).to eq(true)
  end
end
