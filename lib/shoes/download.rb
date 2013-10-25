class Shoes
  class Download

    attr_reader :progress, :content_length

    def initialize app, parent, url, args, &blk
      @blk = blk
      @gui = Shoes.configuration.backend_for(self)
      start_download args, url
    end

    def started?
      @started
    end

    def finished?
      @finished
    end

    def join_thread
      @thread.join
    end

    private
    def start_download args, url
      require 'open-uri'
      @thread = Thread.new do
        options = {content_length_proc: lambda { |length| download_started(length) },
            progress_proc: lambda { |size| @progress = size }}
        open url, options do |download|
          download_data = download.read
          save_to_file(args[:save], download_data) if args[:save]
          finish_download download_data
        end
      end
    end

    def finish_download download_data
      @finished = true
      result   = StringIO.new(download_data)
      eval_block(result) if @blk
    end

    def eval_block(result)
      @gui.eval_block(result, &@blk)
    end

    def save_to_file file_path, download_data
      open(file_path, 'wb') { |fw| fw.print download_data }
    end

    def download_started(length)
      @content_length = length
      @started = true
    end
  end
end
