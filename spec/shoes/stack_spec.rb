require 'shoes/spec_helper'
require_relative 'helpers/fake_element'

describe Shoes::Stack do
  let(:app) { Shoes::App.new }
  let(:opts) {Hash.new}
  subject { Shoes::Stack.new(app, app, opts) }

  it_behaves_like "Slot"

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

  describe 'positioning' do
    it_behaves_like 'positioning through :_position'
    it_behaves_like 'positions the first element in the top left'
    it_behaves_like 'arranges elements underneath each other'
  end
end
