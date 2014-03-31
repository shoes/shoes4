class Shoes
  class Download

    attr_reader :progress, :content_length, :length, :gui, :transferred
    UPDATE_STEPS = 100

    def initialize(app, parent, url, opts = {}, &blk)
      @opts = opts
      @blk = blk
      @transferred = 0
      
      @gui = Shoes.configuration.backend_for(self)
      start_download url
    end
    
    # This method is needed for the specs
    def join_thread
      @thread.join
    end

    def started?
      @started
    end

    def finished?
      @finished
    end

    def percent
      @transferred * 100 / @content_length
    end

    def abort
      @thread.exit if @thread
    end

    private
    def start_download url
      require 'open-uri'
      @thread = Thread.new do
        uri_opts = {}
        uri_opts[:content_length_proc] = content_length_proc
        uri_opts[:progress_proc] = progress_proc if @opts[:progress]

        download_file(url, uri_opts)
      end
    end

    def content_length_proc
      lambda do |content_length| 
        download_started(content_length) 
        eval_block(@opts[:progress], self) if @opts[:progress]
      end
    end

    def progress_proc
      #This proc gets called after every packet transfer. That means on average it gets called 
      #about ten times faster than the gui can handle updating. So we check two things before 
      #firing its contents: 
      #    1) Just update each 1 percent (UPDATE_STEPS = 100) 
      #    2) Depending on file size and internet speed, that 
      #       still could be too fast. So we also have a variable
      #       which gets toggled off while waiting for an asyncEvent.
      #       I decided to make the toggled variable an array just so
      #       that I could use language like queue and empty?.
      lambda do |size|
        if (size - self.transferred) > (content_length / UPDATE_STEPS) && @gui.async_queue.empty?
          @gui.async_queue << "asyncEvent"
          eval_block(@opts[:progress], self)
          @transferred = size
        end
      end
    end

    def download_file(url, uri_opts)
      open url, uri_opts do |download|
        download_data = download.read
        save_to_file(@opts[:save], download_data) if @opts[:save]
        finish_download download_data
      end
    end

    def finish_download download_data
      @finished = true
      result   = StringIO.new(download_data)
      @transferred = @content_length #last progress_proc may not catch this event
      eval_block(@opts[:progress], self) if @opts[:progress]

      eval_block(@blk, result) if @blk
      eval_block(@opts[:finish], self) if @opts[:finish]
    end

    def eval_block(blk, result)
      @gui.eval_block(blk, result)
    end

    def save_to_file file_path, download_data
      open(file_path, 'wb') { |fw| fw.print download_data }
    end

    def download_started(content_length)
      @content_length = content_length
      @length = content_length
      @started = true
    end
  end
end
