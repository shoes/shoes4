require 'swt_shoes/spec_helper'

describe SwtShoes::Animation do
  class AnimationShoeLaces
    include SwtShoes::Animation
    # This is painfully duplicated from Shoes::Animation
    def initialize(*opts, &blk)
      @style = opts.last.class == Hash ? opts.pop : {}
      @style[:framerate] = opts.first if opts.length == 1
      @framerate = @style[:framerate] || 24
      @blk = blk
      @current_frame = 0
      gui_init
    end
  end

  let(:block) { Proc.new {} }
  let(:display) { Swt.display }
  let(:gui_container) { double(:gui_container) }
  subject { AnimationShoeLaces.new &block }

  it "injects into Shoes::Animation" do
    Shoes::Animation.ancestors.should include(SwtShoes::Animation)
  end

  it "triggers an Swt timer" do
    display.should_receive :timer_exec
    subject
  end

  describe "frames" do
    it "counts frames" do
      pending "this feature works in an app, but not in this spec. Need some creativity."
      # Using a real Shoes::Animation here
      animation = Shoes::Animation.new gui_container, 30 do
        "no-op"
      end
      sleep(1)
      animation.instance_variable_get(:@current_frame).should be > 1
    end
  end
end
