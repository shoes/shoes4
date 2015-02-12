class Shoes
  ICON = File.join(DIR, 'static/shoes-icon.png').freeze

  # Instantiates a new Shoes app.
  #
  # @param opts [Hash] A hash of options used instantiate the Shoes::App object with.
  # @param blk  [Proc] The block containing the DSL instructions for the actual app.
  #
  # @example
  #   Shoes.app(title: "Chunky") do
  #     para "Bacon is awesome!"
  #   end
  #
  # @return A new instance of Shoes::App
  #
  # @see Shoes::App#initialize

  def self.app(opts = {}, &blk)
    Shoes::App.new(opts, &blk)
  end

  # This is the user-facing App object. It is `self` inside of a Shoes.app
  # block, and is the context in which a Shoes app is evaled. It delegates most
  # of its functionality to an InternalApp object, which interacts with other
  # Shoes objects. There should be no unnecessary instance variables or methods
  # in this class, so users are free to use whatever names they choose for
  # their own code.
  class App
    include DSL
    include BuiltinMethods
    include Common::Inspect

    # Instantiates a new Shoes app.
    #
    # @param  opts [Hash] The options to initialize the app with.
    # @param  blk  [Proc] The block containing the DSL instructions to be executed within the app.
    #
    # @option opts [String]  :title      ("Shoes 4") The title of the window
    # @option opts [Boolean] :resizable  (true)      Whether the window is resizable
    # @option opts [Boolean] :fullscreen (false)     Whether the app should start in fullscreen
    # @option opts [Fixnum]  :width      (600)       The width of the app window
    # @option opts [Fixnum]  :height     (500)       The height of the app window
    #
    # @see Dimension#initialize
    def initialize(opts = {}, &blk)
      @__app__ = Shoes::InternalApp.new(self, opts, &blk)
      @__app__.setup_gui
      Shoes.register self
      @__app__.open_gui
    end

    # Shoes 3 exposes the app object like this, so we keep it for
    # compatibility
    def app
      self
    end

    def gui
      @__app__.gui
    end

    def window(options = {}, &block)
      options.merge! owner: self
      self.class.new(options, &block)
    end

    def close
      quit
    end

    def quit
      Shoes.unregister self
      @__app__.quit
    end

    def parent
      @__app__.current_slot.parent
    end

    %w(
      width height owner started? location left top absolute_left
      absolute_top click release clear fullscreen fullscreen=
      contents wait_until_closed
    ).each do |method|
      define_method method do |*args, &block|
        @__app__.public_send method, *args, &block
      end
    end

    alias_method :fullscreen?, :fullscreen

    def eval_with_additional_context(context, &blk)
      @__additional_context__ = context
      instance_eval(&blk) if blk
    ensure
      @__additional_context__ = nil
    end

    def method_missing(name, *args, &blk)
      if @__additional_context__
        @__additional_context__.public_send(name, *args, &blk)
      else
        super
      end
    end

    private

    def inspect_details
      " \"#{@__app__.app_title}\""
    end

    def to_s_details
      inspect_details
    end

    DELEGATE_BLACKLIST = [:parent, :app]

    # class definitions are evaluated top to bottom, want to have all of them
    # so define at bottom
    DELEGATE_METHODS = ((Shoes::App.public_instance_methods(false) +
                         Shoes::DSL.public_instance_methods) - DELEGATE_BLACKLIST).freeze

    def self.subscribe_to_dsl_methods(klazz)
      klazz.extend Forwardable unless klazz.is_a? Forwardable
      klazz.def_delegators :app, *DELEGATE_METHODS
      @method_subscribers ||= []
      @method_subscribers << klazz
    end

    def self.new_dsl_method(name, &blk)
      define_method name, blk
      @method_subscribers.each { |klazz| klazz.def_delegator :app, name }
    end
  end
end
