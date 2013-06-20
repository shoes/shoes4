module Shoes
  class Download
    def initialize app, name, args, &blk
      require 'open-uri'
      @thread = Thread.new do
        open name,
          content_length_proc: lambda{|len| @content_length, @started = len, true},
          progress_proc: lambda{|size| @progress = size} do |sio|
          open(args[:save], 'wb'){|fw| fw.print sio.read} if args[:save]
          @finished, @sio = true, sio
        end
      end
      a = app.animate 10 do
        (a.remove; blk[@sio]) if @finished
      end if blk
    end
    
    attr_reader :progress, :content_length
    
    def join_thread
      @thread.join
    end

    def started?
      @started
    end
    
    def finished?
      @finished
    end
  end
end
