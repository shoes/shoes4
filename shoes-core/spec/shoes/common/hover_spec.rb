require 'spec_helper'

describe Shoes::Common::Hover do
  let(:app) { double('app', add_mouse_hover_control: nil) }
  let(:test_class) {
    Class.new {
      include Shoes::Common::Hover

      attr_accessor :app

      def initialize(app)
        @app = app
      end
    }
  }

  subject { test_class.new(app) }

  it_behaves_like "object with hover"
end
