class Shoes
  module Swt
    module Common
      module Resource
        def reset_graphics_context(graphics_context)
          dispose_previous_contexts
          set_defaults_on_context(graphics_context)
          track_graphics_context(graphics_context)
        end

        def dispose_previous_contexts
          @graphic_contexts ||= []
          @graphic_contexts.each { |g| g.dispose if g }
          @graphic_contexts.clear
        end

        def set_defaults_on_context(graphics_context)
          graphics_context.set_antialias(::Swt::SWT::ON)
          graphics_context.set_line_cap(::Swt::SWT::CAP_FLAT)
          graphics_context.set_transform(nil)
        end

        def track_graphics_context(graphics_context)
          @graphic_contexts << graphics_context
        end
      end
    end
  end
end
