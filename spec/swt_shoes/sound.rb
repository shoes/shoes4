require 'swt_shoes/spec_helper'

describe Shoes::Swt::Sound do
  let(:dsl) { double('dsl') }
  let(:filepath) { double('filepath') }
  subject { Shoes::Swt::Sound.new(dsl, filepath) }

  its(:dsl) { is_expected.to be(parent) }
  its(:filepath) { is_expected.to be(filepath) }
end
