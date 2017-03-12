# frozen_string_literal: true
# The methods defined in this module/file are also available outside of the
# Shoes.app block. So they are monkey patched onto the main object.
# However they can also be used from the normal Shoes.app block.
class Shoes
  def self.p(message)
    Shoes.logger.debug(message.inspect)
  end

  module BuiltinMethods
    include Color::DSLHelpers

    def alert(message = '')
      Shoes::Dialog.new.alert message
    end

    def confirm(message = '')
      Shoes::Dialog.new.confirm(message)
    end

    %w(info debug warn error).each do |log_level|
      define_method(log_level) do |message = ''|
        Shoes.logger.public_send(log_level, message)
      end
    end

    alias confirm? confirm

    def ask_open_file
      Shoes::Dialog.new.dialog_chooser 'Open File...'
    end

    def ask_save_file
      Shoes::Dialog.new.dialog_chooser 'Save File...', false, :save
    end

    def ask_open_folder
      Shoes::Dialog.new.dialog_chooser 'Open Folder...', :folder
    end

    def ask_save_folder
      Shoes::Dialog.new.dialog_chooser 'Save Folder...', :folder, :save
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

  # make the builtin methods available on the Shoes class
  extend BuiltinMethods
end

# including the module into the main object for availability on the top level
extend Shoes::BuiltinMethods
