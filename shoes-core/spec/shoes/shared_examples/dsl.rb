# Shared examples for Shoes::App and Shoes::Slot (flow and stack).
# If DSL methods can be called with multiple number of arguments,
# and if they set certain defaults, then that what needs to be tested
# here.
# There are individual specs for the different Shoes elements, so
# we don't need to test how they work in details. Here we just test that
# the DSL methods construct elements correctly.
shared_examples "DSL container" do
  let(:dsl) { app }

  %w[
    animate
    arc
    background
    button
    border
    cap
    check
    edit_box
    edit_line
    fill
    flow
    gradient
    image
    line
    nofill
    nostroke
    oval
    pattern
    progress
    rect
    rgb
    shape
    star
    stroke
    strokewidth
    style
    video
  ].each do |method|
    include_examples "#{method} DSL method"
  end

  include_examples "text element DSL methods"
end
