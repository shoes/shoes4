class Shoes
  class HttpResponse
    # Struct might be better?
    attr_accessor :headers, :body, :status
    def initalize
      @headers = {}
      @body = ''
      @status = []
    end
  end

  class Download

    attr_reader :progress, :response, :content_length, :gui, :transferred
    UPDATE_STEPS = 100

    def initialize(app, parent, url, opts = {}, &blk)
      @url = url
      @opts = opts
      @blk = blk
      @gui = Shoes.configuration.backend_for(self)

      @response = HttpResponse.new
      @finished = false
      @transferred = 0
      @content_length = 1 # non zero initialized to avoid Zero Div Errors
    end

    def start
      start_download
    end

    def started?
      @started
    end

    def finished?
      @finished
    end

    # needed for the specs (jay multi threading and specs)
    def join_thread
      @thread.join unless @thread.nil?
    end

    def percent
      @transferred * 100 / @content_length
    end

    def abort
      @thread.exit if @thread
    end

    # shoes 3 compatibility
    def length
      @content_length
    end

    private
    def start_download
      require 'open-uri'
      @thread = Thread.new do
        uri_opts = {}
        uri_opts[:content_length_proc] = content_length_proc
        uri_opts[:progress_proc] = progress_proc if @opts[:progress]

        open @url, uri_opts do |download_data|
          @response.body = download_data.read
          @response.status = download_data.status
          @response.headers = download_data.meta
          save_to_file(@opts[:save]) if @opts[:save]
          finish_download download_data
        end
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
        if !content_length.nil? &&
          (size - self.transferred) > (content_length / UPDATE_STEPS) &&
          !@gui.busy?
            @gui.busy = true
            eval_block(@opts[:progress], self)
            @transferred = size
        end
      end
    end

    def finish_download(download_data)
      @finished = true

      #In case backend didn't catch the 100%
      @transferred = @content_length
      eval_block(@opts[:progress], self) if @opts[:progress]

      #:finish and block are the same
      eval_block(@blk, self) if @blk
      eval_block(@opts[:finish], self) if @opts[:finish]
    end

    def eval_block(blk, result)
      @gui.eval_block(blk, result)
    end

    def save_to_file(file_path)
      open(file_path, 'wb') { |fw| fw.print @response.body }
    end

    def download_started(content_length)
      @content_length = content_length
      @started        = true
    end
  end
end
