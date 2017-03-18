# frozen_string_literal: true
require 'spec_helper'

describe Shoes::Swt::ShellControlListener do
  let(:app) { double 'SWT App', dsl: dsl_app, shell: shell, real: real }
  let(:shell) { double('Shell').as_null_object }
  let(:dsl_app) { double('DSL App').as_null_object }
  let(:resize_event) { double 'resize_event', widget: shell }
  let(:real) { double('Swt Real').as_null_object }

  subject { Shoes::Swt::ShellControlListener.new(app) }
  before :each do
    subject.controlResized(resize_event)
  end

  describe 'resize' do
    it 'calls the resize block' do
      expect(dsl_app).to have_received(:trigger_resize_callbacks)
    end
  end
end
