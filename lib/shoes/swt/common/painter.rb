class Shoes
  module Swt
    module Common
      class Painter
        include ::Swt::Events::PaintListener
        include Resource
        LINECAP = {curve: ::Swt::SWT::CAP_ROUND, rect: ::Swt::SWT::CAP_FLAT, project: ::Swt::SWT::CAP_SQUARE}

        def initialize(obj)
          @obj = obj
        end

        def paint_control(event)
          graphics_context = event.gc
          gcs_reset graphics_context
          unless @obj.dsl.hidden
            graphics_context.set_antialias ::Swt::SWT::ON
            graphics_context.set_line_cap(LINECAP[@obj.dsl.style[:cap]] || LINECAP[:rect])
            graphics_context.set_transform(@obj.transform)
            obj = @obj.dsl
            case obj
            when ::Shoes::Oval, ::Shoes::Rect
              set_rotate graphics_context, @obj.angle, obj.absolute_left+obj.width/2.0, obj.absolute_top+obj.height/2.0 do
                fill graphics_context if fill_setup(graphics_context)
                draw graphics_context if draw_setup(graphics_context)
              end
            else
              fill graphics_context if fill_setup(graphics_context)
              draw graphics_context if draw_setup(graphics_context)
            end
          end
        end

        # Override in subclass and return something falsy if not using fill
        def fill_setup(graphics_context)
          @obj.apply_fill(graphics_context)
        end

        # Implement in subclass
        def fill(graphics_context)
        end

        # Override in subclass and return something falsy if not using draw
        def draw_setup(graphics_context)
          @obj.apply_stroke(graphics_context)
        end

        # Implement in subclass
        def draw(graphics_context)
        end

        def set_position_and_size
          @obj.left = @obj.dsl.parent.absolute_left
          @obj.top = @obj.dsl.parent.absolute_top
          @obj.width = @obj.dsl.width || @obj.dsl.parent.width
          @obj.height = @obj.dsl.height || @obj.dsl.parent.height
        end

        def set_rotate graphics_context, angle, left, top
          angle, left, top = angle.to_i, left.to_i, top.to_i
          if block_given?
            tr = ::Swt::Transform.new Shoes.display
            reset_rotate tr, graphics_context, angle, left, top
            yield
            reset_rotate tr, graphics_context, -angle, left, top
          end
        end

        def reset_rotate tr, graphics_context, angle, left, top
          tr.translate left, top
          tr.rotate angle
          tr.translate -left, -top
          graphics_context.setTransform tr
        end
      end
    end
  end
end
