require 'swt_shoes/spec_helper'

describe Shoes::Swt::Animation do
  include_context 'swt app'
  let(:dsl) { double('dsl', :stopped? => false, :removed? => false,
                     :framerate => 10, :current_frame => nil,
                     :increment_frame => nil, :blk => block) }
  let(:block) { double 'block', call: nil }
  let(:display) { ::Swt.display }
  subject { Shoes::Swt::Animation.new dsl, swt_app }

  before :each do
    display.stub(:timer_exec)
  end

  it "triggers an Swt timer" do
    display.should_receive(:timer_exec)
    subject
  end

  it "gets framerate" do
    expect(dsl).to receive(:framerate)
    subject
  end

  describe "task" do
    let(:task) { subject.task }

    it "calls block" do
      expect(block).to receive(:call)
      task.call
    end

    it "gets framerate" do
      expect(dsl).to receive(:framerate)
      task.call
    end

    it "triggers redraw" do
      with_redraws do
        expect(swt_app).to receive(:flush)
        task.call
      end
    end

    it "counts frames" do
      expect(dsl).to receive(:increment_frame)
      task.call
    end

    describe 'disabled' do
      it 'does not call the block when stopped' do
        dsl.stub :stopped? => true
        task.call
        expect(block).to_not have_received :call
      end

      it 'does not call the block when removed' do
        dsl.stub :removed? => true
        task.call
        expect(block).to_not have_received :call
      end
    end

  end
end
