require 'shoes/swt/spec_helper'

describe Shoes::Swt::ShellControlListener do
  let(:app) {double 'SWT App', dsl: dsl_app, shell: shell, real: real}
  let(:shell) {double('Shell').as_null_object}
  let(:resize_callbacks) {[]}
  let(:dsl_app) {double('DSL App', resize_callbacks: resize_callbacks).as_null_object}
  let(:block) {double 'Block', call: nil}
  let(:resize_event) {double 'resize_event', widget: shell}
  let(:real) {double('Swt Real').as_null_object}

  subject {Shoes::Swt::ShellControlListener.new(app)}
  before :each do
    subject.controlResized(resize_event)
  end

  describe 'resize' do
    let(:resize_callbacks ){[block]}
    it 'calls the resize block' do
      expect(block).to have_received(:call)
    end
  end
end
