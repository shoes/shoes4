require 'swt_shoes/spec_helper'

describe Shoes::Swt::MouseMoveListener do
  let(:app) {double 'SWT App', dsl: dsl_app, shell: shell,
                    clickable_elements: clickable_elements}
  let(:clickable_elements) {[]}
  let(:mouse_hover_controls) {[]}
  let(:mouse_motion) {[]}
  let(:shell) {double 'Shell', setCursor: nil}
  let(:dsl_app) {double('DSL App', mouse_hover_controls: mouse_hover_controls,
                        mouse_motion: mouse_motion).as_null_object}
  let(:x) {10}
  let(:y) {42}
  let(:block) {double 'Block', call: nil}
  let(:mouse_event) {double'mouse event', x: x, y: y}

  subject {Shoes::Swt::MouseMoveListener.new(app)}
  before :each do
    subject.mouse_move(mouse_event)
  end

  it {should_not be_nil}
  describe 'mouse position' do
    it 'receives the correct mouse position' do
      expect(dsl_app).to have_received(:mouse_pos=).with([x, y])
    end
  end

  describe 'mouse motion' do
    let(:mouse_motion) {[block]}

    it 'calls the block with the position' do
      expect(block).to have_received(:call).with(x, y)
    end
  end

  describe 'shape control' do
    let(:hand_cursor) {Shoes::Swt::Shoes.display.getSystemCursor(::Swt::SWT::CURSOR_HAND)}
    let(:arrow_cursor) {Shoes::Swt::Shoes.display.getSystemCursor(::Swt::SWT::CURSOR_ARROW)}

    context 'over a clickable element' do
      let(:clickable_elements) {[double('element', in_bounds?: true)]}
      it 'should set the curser hand' do
        expect(shell).to have_received(:setCursor).with(hand_cursor)
      end
    end

    context 'not over a clickable element' do
      let(:clickable_elements) {[double('element', in_bounds?: false)]}
      it 'should set the curser hand' do
        expect(shell).to have_received(:setCursor).with(arrow_cursor)
      end
    end
  end

  describe 'hover control' do
    let(:element) {double 'element', in_bounds?: in_bounds?, hovered?: hovered?,
                          hover_proc: element_hover, leave_proc: element_leave,
                          mouse_left: nil, mouse_hovered: nil}
    let(:element_hover) {double 'element hover', call: nil}
    let(:element_leave) {double 'element leave', call: nil}
    let(:mouse_hover_controls) {[element]}

    shared_examples_for 'does not do anything' do
      it 'calls no hover related methods whatsoever' do
        expect(element).not_to have_received :mouse_left
        expect(element).not_to have_received :mouse_hovered
        expect(element_hover).not_to have_received :call
        expect(element_leave).not_to have_received :call
      end
    end

    context 'in bounds and hovered' do
      let(:in_bounds?) {true}
      let(:hovered?) {true}

      it_behaves_like 'does not do anything'
    end

    context 'out of bounds and not hovered' do
      let(:in_bounds?) {false}
      let(:hovered?) {false}

      it_behaves_like 'does not do anything'
    end

    context 'in bounds and not hovered' do
      let(:in_bounds?) {true}
      let(:hovered?) {false}

      it 'calls the hover block' do
        expect(element_hover).to have_received :call
      end

      it 'calls the hovered method' do
        expect(element).to have_received :mouse_hovered
      end
    end

    context 'out of bounds and hovered' do
      let(:in_bounds?) {false}
      let(:hovered?) {true}

      it 'calls the leave block' do
        expect(element_leave).to have_received :call
      end

      it 'calls the mouse_left method' do
        expect(element).to have_received :mouse_left
      end
    end

    describe 'with 2 elements' do
      let(:in_bounds?) {false}
      let(:hovered?) {true}

      let(:element2) {double 'element 2', in_bounds?: true, hovered?: false,
                             hover_proc: element2_hover, leave_proc: nil,
                             mouse_left: nil, mouse_hovered: nil}
      let(:element2_hover) {double 'element 2 hover', call: nil}
      let(:mouse_hover_controls) {[element, element2]}

      it 'calls leave for element 1 before calling hover for element 2' do
        expect(element_leave).to receive(:call).ordered
        expect(element2_hover).to receive(:call).ordered
        subject.mouse_move(mouse_event)
      end
    end
  end
end