class Shoes
  class HttpResponse
    # Struct might be better?
    attr_accessor :headers, :body, :status
    def initialize
      @headers = {}
      @body = ''
      @status = []
    end
  end

  class Download
    attr_reader :app, :progress, :response, :content_length, :gui, :transferred

    UPDATE_STEPS = 100

    def initialize(app, _parent, url, opts = {}, &blk)
      @app = app
      @url = url

      @opts = opts
      @body    = opts[:body]
      @headers = opts[:headers] || {}
      @method  = opts[:method] || "GET"

      initialize_blocks(app, blk)

      @gui = Shoes.backend_for(self)

      @response = HttpResponse.new
      @finished = false
      @transferred = 0
      @content_length = 1 # non zero initialized to avoid Zero Div Errors
    end

    def initialize_blocks(app, blk)
      slot = app.current_slot
      @blk = slot.create_bound_block(blk)
      @progress_blk = slot.create_bound_block(@opts[:progress])
      @finish_blk = slot.create_bound_block(@opts[:finish])
      @error_blk = slot.create_bound_block(@opts[:error] || default_error_proc)
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
      return 0 if @transferred.nil? || @content_length.nil?
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
      @thread = Thread.new do
        begin
          wrapper = Shoes::HttpWrapper.new
          wrapper.execute(@url, @method, @body, @headers) do |response, chunk|
            download_started(response)

            @response.body += chunk
            try_progress(@response.body.length)
          end

          save_to_file(@opts[:save]) if @opts[:save]
          finish_download
        rescue SocketError => e
          Shoes.logger.error e
        rescue => e
          eval_block(@error_blk, e)
        end
      end
    end

    def default_error_proc
      lambda do |exception|
        Shoes.logger.error "Failure downloading #{@url}. To handle this yourself, pass `:error` option to the download call."
        Shoes.logger.error exception.message
        Shoes.logger.error exception.backtrace.join("\n\t")
      end
    end

    def try_progress(size)
      if should_mark_progress?(size)
        @transferred = size
        mark_progress
      end
    end

    def mark_progress
      @gui.busy = true
      eval_block(@progress_blk, self)
    end


    def should_mark_progress?(size)
      !content_length.nil? &&
        (size - transferred) > (content_length / UPDATE_STEPS) &&
        !@gui.busy?
    end

    def finish_download
      @finished = true

      # In case backend didn't catch the 100%
      @transferred = @content_length
      eval_block(@progress_blk, self)

      #:finish and block are the same
      eval_block(@blk, self)
      eval_block(@finish_blk, self)
    end

    def eval_block(blk, result)
      return if blk.nil?
      @gui.eval_block(blk, result)
    end

    def save_to_file(file_path)
      open(file_path, 'wb') { |fw| fw.print @response.body }
    end

    def download_started(response)
      unless @started
        @started = true
        @content_length = read_content_length(response)

        @response.status = [response.code, response.message]
        response.each_header do |(key, value)|
          @response.headers[key] = response[key]
        end

        mark_progress
      end
    end

    def read_content_length(response)
      len = response["Content-Length"]
      len.nil? ? nil : len.to_i
    end
  end
end
