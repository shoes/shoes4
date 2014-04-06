require 'uri'
require 'stringio'

module ShoesHTTP
  def ShoesHTTP.download(name, opts={}, &blk)

    require 'net/http'

    @uri = URI::Generic === name ? name : URI.parse(name)
    @buf = Buffer.new
    @header ||= opts[:headers]
    @opts = opts
    #@header.each {|k, v| @header[k] = v } if @header
    @response = "" #this is the only way I know how to get the response block's response back out of the block when we're through :(

    Net::HTTP.start(@uri.hostname, @uri.port) do |http|
      case
      when opts[:method] == "GET" || opts[:method] == nil
        req = Net::HTTP::Get.new(@uri.request_uri)
      when opts[:method] == "POST"
        req = Net::HTTP::Post.new(@uri.request_uri)
        req.body = opts[:body]
      when opts[:method] == "HEAD"
        req = Net::HTTP::Head.new(@uri.request_uri)
      else
        raise ArgumentError, "#{opts[:method]} is not a method download can handle right now. Try GET, POST or HEAD."
      end #case
      @header.each{|k,v| req[k] =  v} if @header

      @response = http.request(req) do |resp|
        if @opts[:content_length_proc] && Net::HTTPSuccess === resp
          if resp.key?('Content-Length')
            @opts[:content_length_proc].call(resp['Content-Length'].to_i)
          else
            @opts[:content_length_proc].call(nil)
          end
        end
        resp.read_body do |str|
          @buf << str
          if @opts[:progress_proc] && Net::HTTPSuccess === resp
            @opts[:progress_proc].call(@buf.size)
          end
        end
      end
    end #net http do

    io = @buf.io 
    io.rewind
    response = HTTPResponse.new(io, @response)
    blk.call(response) if blk
  end

  class Buffer 
    def initialize
      @io = StringIO.new
      @size = 0
    end
    attr_reader :size

    StringMax = 10240
    def <<(str)
      @io << str
      @size += str.length
      if StringIO === @io && StringMax < @size
        require 'tempfile'
        io = Tempfile.new('open-uri')
        io.binmode
        Meta.init io, @io if Meta === @io
        io << @io.string
        @io = io
      end
    end

    def io
      Meta.init @io unless Meta === @io
      @io
    end
  end

  module Meta
    def Meta.init(obj, src=nil) # :nodoc:
      obj.extend Meta
      obj.instance_eval {
        @base_uri = nil
        @meta = {} # name to string.  legacy.
        @metas = {} # name to array of strings.
      }
      if src
        obj.status = src.status
        obj.base_uri = src.base_uri
        src.metas.each {|name, values|
          obj.meta_add_field2(name, values)
        }
      end
    end
  end

end
