class Shoes
  class Download

    attr_reader :progress, :length, :gui

    def initialize app, parent, url, args, &blk
      @args = args
      @blk = blk
      @gui = Shoes.configuration.backend_for(self)
      @finished = false
      start_download url
    end

    def started?
      @started
    end

    def finished?
      @finished
    end
#unused? delete?
    def join_thread
      @thread.join
    end

    def transferred
      @progress
    end

    def percent
      (@progress.to_f / @length.to_f * 100.0).round
    end

    def abort
      @thread.exit if @thread
    end

    private
    def start_download url
      require 'open-uri'

      @thread = Thread.new do
        
        $async_has_finished = true

        options = {
    
          content_length_proc: #fired before download starts
          lambda do |length| 
            download_started(length) 
            eval_block(@args[:start], self) if @args[:start]
          end,

          progress_proc: #fired with each transfer
          lambda do |size|
            @progress = size
            if $async_has_finished && @args[:progress]
              $async_has_finished = false
              eval_block(@args[:progress], self)
            end
          end
        }

        options[:method] =  @args[:method] if @args[:method]
        options[:headers] = @args[:headers] if  @args[:headers]
        options[:body] =    @args[:body] if @args[:body]

        open url, options do |download|
          download_data = download.read
          save_to_file(@args[:save], download_data) if @args[:save]
          finish_download download_data
        end
      end

    end

    def finish_download download_data
      @finished = true
      result   = StringIO.new(download_data)
      #one last progress fire in case final asyncEvent didn't catch the 100%
      eval_block(@args[:progress], self) if @args[:progress]
      eval_block(@blk, result) if @blk
      eval_block(@args[:finish], self) if @args[:finish]

    end

    def eval_block(blk, result)
      @gui.eval_block(blk, result)
    end

    def save_to_file file_path, download_data
      open(file_path, 'wb') { |fw| fw.print download_data }
    end

    def download_started(length)
      @length = length
      @started = true
    end
  end
end
