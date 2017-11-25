# frozen_string_literal: true

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
        }.freeze

        def initialize(obj)
          @obj = obj
        end

        def paint_control(event)
          before_painted
          graphics_context = event.gc
          reset_graphics_context graphics_context
          if @obj.dsl.visible? && @obj.dsl.positioned?
            paint_object graphics_context
          end
        rescue => e
          raise e if ENV['SHOES_ENV'] == 'test'

          # Really important to rescue here. Failures that escape this method
          # cause odd-ball hangs with no backtraces. See #559 for an example.
          #
          puts "SWALLOWED PAINT EXCEPTION ON #{@obj} - go take care of it: " + e.to_s
          puts 'Unfortunately we have to swallow it because it causes odd failures :('
        ensure
          after_painted
        end

        def paint_object(graphics_context)
          cap = LINECAP[@obj.dsl.style[:cap]]
          graphics_context.set_line_cap(cap) if cap
          graphics_context.set_transform(@obj.transform)

          obj = @obj.dsl
          clip_context_to(graphics_context, obj.parent, obj.parent.fixed_height?) do
            if obj.needs_rotate?
              set_rotate graphics_context, obj.rotate,
                         obj.element_left + obj.element_width / 2.0,
                         drawing_top + obj.element_height / 2.0 do
                fill_and_draw(graphics_context)
              end
            else
              fill_and_draw(graphics_context)
            end
          end
        end

        def fill_and_draw(graphics_context)
          fill graphics_context if fill_setup(graphics_context)
          draw graphics_context if draw_setup(graphics_context)
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
          angle = angle.to_i
          left = left.to_i
          top = top.to_i
          if block_given?
            begin
              transform = ::Swt::Transform.new Shoes.display

              # Why the negative angle? Older shoes rotated from the middle
              # right running counter clockwise (as seen on this web page:
              # https://www.mathsisfun.com/geometry/degrees.html). To get the
              # same effect, we have to negate the value passed in.
              reset_rotate transform, graphics_context, -angle, left, top
              yield
              reset_rotate transform, graphics_context, angle, left, top
            ensure
              transform.dispose unless transform.nil? || transform.disposed?
            end
          end
        end

        def reset_rotate(transform, graphics_context, angle, left, top)
          transform.translate left, top
          transform.rotate angle
          transform.translate(-left, -top)
          graphics_context.set_transform transform
        end

        def drawing_top
          dsl = @obj.dsl
          dsl.element_top - dsl.parent.scroll_top
        end

        def drawing_bottom
          dsl = @obj.dsl
          dsl.element_bottom - dsl.parent.scroll_top
        end

        def before_painted
        end

        def after_painted
        end
      end
    end
  end
end
