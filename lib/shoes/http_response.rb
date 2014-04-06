class HTTPResponse
    attr_reader :text, :status, :headers, :body
  def initialize(io, response)
    @body = io.read
    @text = @body #These appear to be identical in Shoes3
    @status = response.code
    @headers = response.header.each{ |k, v| "#{k}: #{v}" }
  end
end
