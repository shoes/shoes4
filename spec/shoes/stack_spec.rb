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

    let(:element) {Shoes::FakeElement.new height: 100, width: 50}
    let(:element2) {Shoes::FakeElement.new height: 200, width: 70}

    before :each do
      subject.add_child element
    end

    it 'sends the child the :_position method to position it' do
      element.should_receive :_position
      subject.contents_alignment
    end

    describe 'one element added' do
      before :each do
        subject.contents_alignment
      end

      it 'positions a single object at the same top as self' do
        element.top.should eq subject.top
      end

      it 'positions a single object at the same left as self' do
        element.left.should eq subject.left
      end
    end

    describe 'two elements added' do

      before :each do
        subject.add_child element2
        subject.contents_alignment
      end

      it 'positions an element beneath a previous element' do
        element2.top.should eq element.bottom
      end

      it 'still positions it at the start of the line (e.g. self.left)' do
        element2.left.should eq subject.left
      end
    end
  end
end
