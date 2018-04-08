# frozen_string_literal: true

require 'spec_helper'

describe Shoes::Swt::MouseMoveListener do
  include_context "quiet logging"

  let(:app) do
    double 'SWT App', dsl: dsl_app, shell: shell,
                      clickable_elements: clickable_elements
  end

  let(:clickable_elements) { [] }
  let(:mouse_hover_controls) { [] }
  let(:mouse_motion) { [] }
  let(:shell) { double 'Shell', setCursor: nil }

  let(:display) do
    double('display').tap do |disp|
      allow(disp).to receive(:getSystemCursor).with(Swt::SWT::CURSOR_HAND).and_return(hand_cursor)
      allow(disp).to receive(:getSystemCursor).with(Swt::SWT::CURSOR_ARROW).and_return(arrow_cursor)
    end
  end

  let(:hand_cursor) { double 'hand cursor' }
  let(:arrow_cursor) { double 'arrow cursor' }

  let(:dsl_app) do
    double('DSL App', mouse_hover_controls: mouse_hover_controls,
                      mouse_motion: mouse_motion).as_null_object
  end

  let(:x) { 10 }
  let(:y) { 42 }
  let(:block) { double 'Block', call: nil }
  let(:mouse_event) { double 'mouse event', x: x, y: y }

  subject { Shoes::Swt::MouseMoveListener.new(app) }

  before :each do
    allow(::Shoes::Swt::Shoes).to receive(:display).and_return(display)
    subject.mouse_move(mouse_event)
  end

  describe 'mouse position' do
    it 'receives the correct mouse position' do
      expect(dsl_app).to have_received(:mouse_pos=).with([x, y])
    end
  end

  describe 'mouse motion' do
    let(:mouse_motion) { [block] }

    it 'calls the block with the position' do
      expect(block).to have_received(:call).with(x, y)
    end
  end

  describe 'shape control' do
    context 'over a clickable element' do
      let(:clickable_elements) { [double('element', visible?: true, in_bounds?: true)] }
      it 'should set the curser hand' do
        expect(shell).to have_received(:setCursor).with(hand_cursor)
      end
    end

    context 'not over a clickable element' do
      let(:clickable_elements) { [double('element', visible?: true, in_bounds?: false)] }
      it 'should set the curser hand' do
        expect(shell).to have_received(:setCursor).with(arrow_cursor)
      end
    end
  end

  describe 'hover control' do
    let(:element) do
      double 'element', in_bounds?: in_bounds?, hovered?: hovered?,
                        visible?: true, mouse_left: nil, mouse_hovered: nil
    end

    let(:mouse_hover_controls) { [element] }

    shared_examples_for 'does not do anything' do
      it 'calls no hover related methods whatsoever' do
        expect(element).not_to have_received :mouse_left
        expect(element).not_to have_received :mouse_hovered
      end
    end

    context 'in bounds and hovered' do
      let(:in_bounds?) { true }
      let(:hovered?) { true }

      it_behaves_like 'does not do anything'
    end

    context 'out of bounds and not hovered' do
      let(:in_bounds?) { false }
      let(:hovered?) { false }

      it_behaves_like 'does not do anything'
    end

    context 'in bounds and not hovered' do
      let(:in_bounds?) { true }
      let(:hovered?) { false }

      it 'calls the hovered method' do
        expect(element).to have_received :mouse_hovered
      end
    end

    context 'out of bounds and hovered' do
      let(:in_bounds?) { false }
      let(:hovered?) { true }

      it 'calls the mouse_left method' do
        expect(element).to have_received :mouse_left
      end
    end

    describe 'in bounds, not hovered but hidden' do
      let(:in_bounds?) { true }
      let(:hovered?)   { false }

      let(:element) do
        double 'element', in_bounds?: in_bounds?, hovered?: hovered?,
                          visible?: false, mouse_left: nil, mouse_hovered: nil
      end

      it_behaves_like 'does not do anything'
    end

    describe 'with 2 elements' do
      let(:in_bounds?) { false }
      let(:hovered?) { true }

      let(:element2) do
        double 'element 2', in_bounds?: true, hovered?: false, visible?: true,
                            mouse_left: nil, mouse_hovered: nil
      end

      let(:mouse_hover_controls) { [element, element2] }

      it 'calls leave for element 1 before calling hover for element 2' do
        expect(element).to receive(:mouse_left).ordered
        expect(element2).to receive(:mouse_hovered).ordered
        subject.mouse_move(mouse_event)
      end
    end
  end

  describe 'failure' do
    let(:mouse_motion) do
      [proc { raise "heck" }]
    end

    it 'catches errors' do
      Shoes.configuration.fail_fast = false
      subject.mouse_move(mouse_event)
    end

    it 'raises errors' do
      Shoes.configuration.fail_fast = true
      expect { subject.mouse_move(mouse_event) }.to raise_error(RuntimeError)
    end
  end
end
