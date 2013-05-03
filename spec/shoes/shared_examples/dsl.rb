# Shared examples for Shoes::App and Shoes::Slot (flow and stack)
shared_examples "DSL container" do
  let(:dsl) { subject }

  %w[
    animate
    arc
    background
    border
    fill
    nofill
    oval
    flow
    gradient
    pattern
    line
    rect
    rgb
    shape
    stroke
    nostroke
    cap
    strokewidth
  ].each do |method|
    include_examples "#{method} DSL method"
  end

  include_examples "text element DSL methods"
end
