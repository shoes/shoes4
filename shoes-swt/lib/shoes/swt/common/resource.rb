# frozen_string_literal: true

class Shoes
  module Swt
    module Common
      module Resource
        OPAQUE = 255

        def reset_graphics_context(graphics_context)
          dispose_previous_contexts
          set_defaults_on_context(graphics_context)
          track_graphics_context(graphics_context)
        end

        def dispose_previous_contexts
          @graphic_contexts ||= []
          @graphic_contexts.each { |g| g&.dispose }
          @graphic_contexts.clear
        end

        def set_defaults_on_context(graphics_context)
          graphics_context.set_alpha OPAQUE
          graphics_context.set_antialias(::Swt::SWT::ON)
          graphics_context.set_line_cap(::Swt::SWT::CAP_FLAT)
          graphics_context.set_transform(nil)
        end

        def track_graphics_context(graphics_context)
          @graphic_contexts << graphics_context
        end

        def clip_context_to(graphics_context, element, use_parent_height = true)
          parent   = element.parent
          clipping = graphics_context.clipping
          height   = use_parent_height ? parent.height : parent.app.height

          graphics_context.set_clipping(parent.absolute_left,
                                        parent.absolute_top,
                                        parent.width + element.translate_left.to_i,
                                        height + element.translate_top.to_i)
          yield graphics_context
        ensure
          if clipping
            graphics_context.set_clipping(clipping.x, clipping.y,
                                          clipping.width, clipping.height)
          end
        end
      end
    end
  end
end
