class Shoes
  class Download

    attr_reader :progress, :content_length, :length, :gui, :transferred, :response
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
      if @content_length
      @transferred * 100 / @content_length
      else
        raise ArgumentError, "Can't call percent if content-length header is missing. Check to see if your file is downloadable."
      end
    end

    def abort
      @thread.exit if @thread
    end

    private
    def start_download url
      require 'open-uri'
      @thread = Thread.new do
        @opts[:content_length_proc] = content_length_proc
        @opts[:progress_proc] = progress_proc if @opts[:progress]

        download_file(url, @opts)
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
        if content_length #if the requested url has no content-length header, then don't fire the progress
          if (size - self.transferred) > (content_length / UPDATE_STEPS) && @gui.async_queue.empty?
            @gui.async_queue << "asyncEvent"
            eval_block(@opts[:progress], self)
            @transferred = size
          end
        else
          raise ArgumentError, "Can't call :progress if content-length header is missing. Check to see if your file is downloadable."
        end
      end
    end

    def download_file(url, opts)
      ShoesHTTP.download(url, opts) do |download|
        response = download
        save_to_file(@opts[:save], response.body) if @opts[:save]
        finish_download(response)
      end
    end

    def finish_download(response)
      @finished = true
      @response = response

      @transferred = @content_length #last progress_proc may not catch this event
      eval_block(@opts[:progress], self) if @opts[:progress] #so give it one more shot

      #finish and block are the same
      eval_block(@blk, self) if @blk
      eval_block(@opts[:finish], self) if @opts[:finish]
    end

    def eval_block(blk, result)
      @gui.eval_block(blk, result)
    end

    def save_to_file(file_path, download_data)
      open(file_path, 'wb') { |fw| fw.print download_data }
    end

    def download_started(content_length)
      @content_length = content_length
      @length = content_length
      @started = true
    end

  end
end
