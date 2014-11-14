class Shoes
  # Backwards compatibility, kind of likely to be removed
  def self.inherited(base_class)
    base_class.send :include, URL # include is private, therefore send
  end

  module URL
    attr_accessor :app

    Shoes::App.subscribe_to_dsl_methods self

    def self.included(base_class)
      base_class.extend URLDefiner
    end

    def self.urls
      @urls ||= {}
    end
  end

  module URLDefiner
    def url(page, method)
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
