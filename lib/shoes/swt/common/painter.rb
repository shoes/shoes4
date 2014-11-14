class Shoes
  module Swt
    module Common
      class Painter
        include ::Swt::Events::PaintListener
        include Resource

        LINECAP = {
          curve:   ::Swt::SWT::CAP_ROUND,
          rect:    ::Swt::SWT::CAP_FLAT,
          project: ::Swt::SWT::CAP_SQUARE
        }

        def initialize(obj)
          @obj = obj
        end

        def paint_control(event)
          graphics_context = event.gc
          reset_graphics_context graphics_context
          if @obj.dsl.visible? && @obj.dsl.positioned?
            paint_object graphics_context
          end
        rescue => e
          # Really important to rescue here. Failures that escape this method
          # cause odd-ball hangs with no backtraces. See #559 for an example.
          #
          puts "SWALLOWED PAINT EXCEPTION ON #{@obj} - go take care of it: " + e.to_s
          puts 'Unfortunately we have to swallow it because it causes odd failures :('
        end

        def paint_object(graphics_context)
          cap = LINECAP[@obj.dsl.style[:cap]]
          graphics_context.set_line_cap(cap) if cap
          graphics_context.set_transform(@obj.transform)
          obj = @obj.dsl
          case obj
            when ::Shoes::Oval, ::Shoes::Rect
              set_rotate graphics_context, obj.rotate,
                         obj.element_left + obj.element_width / 2.0,
                         obj.element_top + obj.element_height / 2.0 do
                fill graphics_context if fill_setup(graphics_context)
                draw graphics_context if draw_setup(graphics_context)
              end
            else
              fill graphics_context if fill_setup(graphics_context)
              draw graphics_context if draw_setup(graphics_context)
          end
        end

        # Override in subclass and return something falsy if not using fill
        def fill_setup(graphics_context)
          @obj.apply_fill(graphics_context)
        end

        # Implement in subclass
        def fill(_graphics_context)
        end

        # Override in subclass and return something falsy if not using draw
        def draw_setup(graphics_context)
          @obj.apply_stroke(graphics_context)
        end

        # Implement in subclass
        def draw(_graphics_context)
        end

        def set_rotate(graphics_context, angle, left, top)
          angle, left, top = angle.to_i, left.to_i, top.to_i
          if block_given?
            begin
              transform = ::Swt::Transform.new Shoes.display
              reset_rotate transform, graphics_context, angle, left, top
              yield
              reset_rotate transform, graphics_context, -angle, left, top
            ensure
              transform.dispose unless transform.nil? || transform.disposed?
            end
          end
        end

        def reset_rotate(transform, graphics_context, angle, left, top)
          transform.translate left, top
          transform.rotate angle
          transform.translate -left, -top
          graphics_context.setTransform transform
        end
      end
    end
  end
end
