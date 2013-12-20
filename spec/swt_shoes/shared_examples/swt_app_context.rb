# This is a common context for running Shoes::Swt specs.
#   - parent:    use for instantiating a Shoes::Swt object
#   - swt_app:   use for instantiating a Shoes::Swt object
#   - shoes_app: use for instantiating a Shoes DSL object
shared_context "swt app" do
  let(:swt_app_real) { double('swt app real') }
  let(:swt_app) { double('swt app', real: swt_app_real, disposed?: false, 
                         add_paint_listener: true, remove_paint_listener: true,
                         add_clickable_element: true, add_listener: true) }
  let(:shoes_app) { double('shoes app', gui: swt_app, unslotted_elements: [], rotate: 0) }
  let(:parent) { double('parent', app: swt_app, real: true) }
end

