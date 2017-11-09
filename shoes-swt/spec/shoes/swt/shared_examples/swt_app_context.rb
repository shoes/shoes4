# frozen_string_literal: true

# This is a common context for running Shoes::Swt specs.
#   - parent:    use for instantiating a Shoes::Swt object
#   - swt_app:   use for instantiating a Shoes::Swt object
#   - shoes_app: use for instantiating a Shoes DSL object
shared_context "swt app" do
  let(:swt_app_real) do
    double('swt app real', disposed?: false, set_visible: true)
  end

  let(:clickable_element) { double("clickable_element", delete: nil) }

  let(:click_listener) do
    double("click listener", add_click_listener: nil, add_release_listener: nil,
                             remove_listeners_for: nil)
  end

  let(:swt_app) do
    swt_double = double('swt app', real: swt_app_real, disposed?: false,
                                   add_paint_listener: true, remove_paint_listener: true,
                                   add_clickable_element: true, add_listener: true,
                                   remove_listener: true, flush: true, redraw: true,
                                   click_listener: click_listener,
                                   clickable_elements: clickable_element)
    allow(swt_double).to receive(:app).and_return(swt_double)
    swt_double
  end

  let(:shoes_app) { double('shoes app', gui: swt_app, rotate: 0, style: {}, element_styles: {}) }

  let(:parent) do
    double('parent', app: swt_app, add_child: true, real: true, hidden?: false,
                     scroll_top: 0,
                     absolute_left: 0, absolute_top: 0,
                     width: 200, height: 100, fixed_height?: true)
  end

  let(:parent_dsl) do
    double("parent dsl", add_child: true, contents: [], gui: parent,
                         hidden?: false, fixed_height?: false,
                         absolute_left: 0, absolute_top: 0,
                         width: 200, height: 100,
                         x_dimension: double.as_null_object,
                         y_dimension: double.as_null_object)
  end
end
