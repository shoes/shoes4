shared_context "dsl app" do
  let(:input_block) { Proc.new {} }
  let(:input_opts) { Hash.new }
  let(:user_facing_app) { Shoes::App.new input_opts, &input_block }
  let(:app) { user_facing_app.instance_variable_get(:@__app__) }
  let(:parent) { Shoes::Flow.new app, app,
                                 width: Shoes::InternalApp::DEFAULT_OPTIONS[:width],
                                 height: Shoes::InternalApp::DEFAULT_OPTIONS[:height]
  }
end
