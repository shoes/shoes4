require 'swt_shoes/spec_helper'

describe Shoes::Swt::TextBlock do
  let(:real) { double('real', add_paint_listener: true) }
  let(:gui) { double('gui', real: real) }
  let(:app) { double('app', gui: gui) }
  let(:opts) { {app: app} }
  let(:dsl) { double('dsl').as_null_object }

  subject {
    Shoes::Swt::TextBlock.new(dsl, opts)
  }

  context "#initialize" do
    it { should be_instance_of(Shoes::Swt::TextBlock) }
  end
end
