class Shoes
  class Download

    attr_reader :progress, :content_length, :length, :gui
    UPDATE_STEPS = 50

    def initialize(app, parent, url, opts = {}, &blk)
      @opts = opts
      @blk = blk
      @gui = Shoes.configuration.backend_for(self)
      start_download url
      
      @transferred = 0
    end

    def join_thread
      @thread.join
    end


    def started?
      @started
    end

    def finished?
      @finished
    end

    def transferred
      @transferred
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
      lambda do |size|
        if (size - self.transferred) > (content_length / UPDATE_STEPS)
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
