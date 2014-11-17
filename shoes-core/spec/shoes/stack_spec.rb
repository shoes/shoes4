require 'shoes/spec_helper'
require 'shoes/helpers/fake_element'

describe Shoes::Stack do
  include_context "dsl app"

  subject(:stack) { Shoes::Stack.new(app, app, input_opts) }

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
      expect(inside_stack).to be context_object
    end
  end

  describe 'positioning' do
    it_behaves_like 'positioning through :_position'
    it_behaves_like 'positions the first element in the top left'
    it_behaves_like 'arranges elements underneath each other'

    describe 'small stack height' do
      let(:input_opts){{height: element.height + 10}}
      it_behaves_like 'set height and contents alignment'
    end

    describe 'big stack height' do
      let(:input_opts){{height: 1000}}
      it_behaves_like 'set height and contents alignment'
    end

    describe 'with margin' do
      let(:input_opts){{margin: 27}}
      it_behaves_like 'taking care of margin'
    end
  end

  describe 'scrolling' do
    include_context "scroll"
    subject { Shoes::Stack.new(app, parent, opts) }

    context 'when scrollable' do
      let(:scroll) { true }

      it_behaves_like "scrollable slot"

      context 'when content overflows' do
        include_context "overflowing content"
        it_behaves_like "scrollable slot with overflowing content"
      end
    end

    context 'when slot is not scrollable' do
      let(:scroll) { false }

      its(:scroll) { should be_falsey }

      it "initializes scroll_top to 0" do
        expect(subject.scroll_top).to eq(0)
      end
    end
  end
end
