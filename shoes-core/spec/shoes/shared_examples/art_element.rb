shared_examples "an art element" do
  it_behaves_like "clickable object"
  it_behaves_like "object with hover"
  it_behaves_like "object with rotate"
  it_behaves_like "object with stroke"
  it_behaves_like "object with translate"
end
