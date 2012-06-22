describe Shoes::Swt::Sound do
  let(:dsl) { double('dsl') }
  let(:filepath) { double('filepath') }
  subject { Shoes::Swt::Sound.new(dsl, filepath) }

  its(:dsl) { should be(parent) }
  its(:filepath) { should be(filepath) }
end
