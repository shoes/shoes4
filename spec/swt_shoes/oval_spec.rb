describe SwtShoes::Oval do
  let(:gui_container) { double("gui container") }
  let(:opts) { {:gui => {:container => gui_container}} }

  subject {
    Shoes::Oval.new(10, 15, 100, opts)
  }

  it_behaves_like "paintable"
  it_behaves_like "Swt object with stroke"
  it_behaves_like "Swt object with fill"
end

