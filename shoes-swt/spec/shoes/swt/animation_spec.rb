require 'shoes/swt/spec_helper'

describe Shoes::Swt::Animation do
  include_context 'swt app'
  let(:dsl) { double('dsl', :stopped? => false, :removed? => false,
                     :framerate => 10, :current_frame => nil,
                     :increment_frame => nil, :blk => block) }
  let(:block) { double 'block', call: nil }
  let(:display) { ::Swt.display }
  subject { Shoes::Swt::Animation.new dsl, swt_app }

  before :each do
    allow(display).to receive(:timer_exec)
  end

  it "triggers an Swt timer" do
    expect(display).to receive(:timer_exec)
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
      describe 'stopped?' do
        before :each do
          allow(dsl).to receive_messages :stopped? => true
          task.call
        end

        it 'does not call the block' do
          expect(block).to_not have_received :call
        end

        it 'continues calling the task' do
          # one for initialize, one for the call in the task call
          expect(display).to have_received(:timer_exec).exactly(2).times
        end
      end

      describe 'removed?' do
        before :each do
          allow(dsl).to receive_messages :removed? => true
          task.call
        end

        it 'does not call the block when removed' do
          expect(block).to_not have_received :call
        end

        it 'does not continue calling itself when removed' do
          # one time is initialize
          expect(display).to have_received(:timer_exec).exactly(1).times
        end
      end
    end

  end
end
