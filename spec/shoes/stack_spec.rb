require 'shoes/spec_helper'

describe Shoes::Stack do
  let(:app) { Shoes::App.new }
  subject { Shoes::Stack.new(app, app) }

  it_behaves_like "Slot"
end

describe 'Context' do

  class ContextObject
    def initialize(app)
      @app = app
    end

    def check_self_inside_stack
      inside_stack = nil
      @app.stack do inside_stack = self end
      inside_stack
    end
  end

  it 'does not change the context' do
    app = Shoes.app do ; end
    context_object = ContextObject.new app
    inside_stack = context_object.check_self_inside_stack
    inside_stack.should be context_object
  end
end