# frozen_string_literal: true

shared_context "dsl app" do
  let(:input_block) { proc {} }
  let(:input_opts) { {} }
  let(:user_facing_app) { Shoes::App.new input_opts, &input_block }
  let(:dsl) { user_facing_app }
  let(:app) { user_facing_app.instance_variable_get(:@__app__) }
  let(:parent) do
    Shoes::Flow.new app, app,
                    width: Shoes::InternalApp::DEFAULT_OPTIONS[:width],
                    height: Shoes::InternalApp::DEFAULT_OPTIONS[:height]
  end
end
