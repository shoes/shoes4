# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Swt::Star do
  include_context "swt app"

  let(:left) { 55 }
  let(:top) { 77 }
  let(:points) { 7 }
  let(:outer) { 100 }
  let(:inner) { 20 }
  let(:dsl) { Shoes::Star.new shoes_app, parent, left, top, points, outer, inner }

  subject { Shoes::Swt::Star.new dsl, swt_app }

  context "#initialize" do
    its(:dsl) { is_expected.to be(dsl) }
  end

  it_behaves_like "paintable"
  it_behaves_like "updating visibility"
  it_behaves_like 'clickable backend'
end
