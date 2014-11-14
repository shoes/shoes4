# The methods defined in this module/file are also available outside of the
# Shoes.app block. So they are monkey patched onto the main object.
# However they can also be used from the normal Shoes.app block.
class Shoes
  def self.p(message)
    Shoes::LOG << ['debug', message.inspect]
  end

  module BuiltinMethods
    include Color::DSLHelpers

    def alert(message = '')
      Shoes::Dialog.new.alert message
    end

    def confirm(message = '')
      Shoes::Dialog.new.confirm(message)
    end

    def info(message = '')
      Shoes::LOG << ['info', message]
      Shoes.logger.info message
    end

    def debug(message = '')
      Shoes::LOG << ['debug', message]
      Shoes.logger.debug message
    end

    def warn(message = '')
      Shoes::LOG << ['warn', message]
      Shoes.logger.warn message
    end

    def error(message = '')
      Shoes::LOG << ['error', message]
      Shoes.logger.error message
    end

    alias_method :confirm?, :confirm

    def ask_open_file
      Shoes::Dialog.new.dialog_chooser 'Open File...'
    end

    def ask_save_file
      Shoes::Dialog.new.dialog_chooser 'Save File...'
    end

    def ask_open_folder
      Shoes::Dialog.new.dialog_chooser 'Open Folder...', :folder
    end

    def ask_save_folder
      Shoes::Dialog.new.dialog_chooser 'Save Folder...', :folder
    end

    def ask(msg, args = {})
      Shoes::Dialog.new.ask msg, args
    end

    def ask_color(title = 'Pick a color...')
      Shoes::Dialog.new.ask_color title
    end

    def font(path = DEFAULT_TEXTBLOCK_FONT)
      Shoes::Font.add_font(path)
    end
  end

  extend BuiltinMethods
end

# including the module into the main object (monkey patch)
class << self
  include Shoes::BuiltinMethods
end
