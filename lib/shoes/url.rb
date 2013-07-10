class Shoes

  # Backwards compatibility, kind of likely to be removed
  def self.inherited(base_class)
    base_class.send :include, URL #include is private, therefore send
  end

  module URL

    def self.included(base_class)
      base_class.extend URLDefiner
    end

    def self.urls
      @urls ||= {}
    end

    attr_accessor :app

    def method_missing(method, *args, &blk)
      if app_should_handle_method? method
        app.send(method, *args, &blk)
      else
        super
      end
    end

    private
    def app_should_handle_method? method_name
      !self.respond_to?(method_name) && app.respond_to?(method_name)
    end
  end

  module URLDefiner
    def url page, method
      page = convert_page_to_regex(page)
      url_class = self

      Shoes::URL.urls[page] = proc do |app, arg|
        new_url_instance = url_class.new
        new_url_instance.app = app
        if arg
          new_url_instance.send(method, arg)
        else
          new_url_instance.send method
        end
      end
    end

    private
    def convert_page_to_regex(page)
      /^#{page}$/
    end
  end
end
