
#require 'white_shoes/base'
require 'white_shoes/animation'
require 'white_shoes/app'
require 'white_shoes/flow'
require 'white_shoes/button'
require 'white_shoes/line'
require 'white_shoes/oval'
require 'white_shoes/shape'
require 'white_shoes/sound'

module WhiteShoes

    #def adapter
    #  WhiteShoes
    #end
    #
    ## Adapts the BaseView methods specific for the framework
    #class BaseNative < Base
    #  # Queues the block call, so that it is only gets executed in the main thread.
    #  def queue(&block)
    #  end
    #
    #  # Adds a widget to the given container widget.
    #  def add_widget_to_container(widget, container_widget)
    #  end
    #
    #  # Removes a widget from the given container widget.
    #  def remove_widget_from_container(widget, container_widget)
    #  end
    #
    #  # Removes all children from the given container widget.
    #  def remove_all_children(container_widget)
    #  end
    #
    #  # Sets the widget name for the given widget if given.
    #  def set_widget_name(widget, widget_name)
    #  end
    #
    #  # Autoconnects signals handlers for the view. If +other_target+ is given
    #  # it is used instead of the view itself.
    #  def autoconnect_signals(view, other_target = nil)
    #  end
    #
    #  # Connects the signal from the widget to the given receiver block.
    #  # The block is executed in the context of the receiver.
    #  def connect_declared_signal_block(widget, signal, receiver, block)
    #  end
    #
    #  # Connects the signal from the widget to the given receiver method.
    #  def connect_declared_signal(widget, signal, receiver, method)
    #  end
    #
    #  # Builds widgets from the given filename, using the proper builder.
    #  def build_widgets_from(filename)
    #  end
    #
    #  # Registers widgets as attributes of the view class.
    #  def register_widgets
    #  end
    #
    #  class << self
    #    # Returns the builder file extension to be used for this view class.
    #    def builder_file_extension
    #    end
    #  end
    #end

    ## Adapts the BaseViewHelper methods specific for the framework
    #class BaseViewHelper
    #end

end

