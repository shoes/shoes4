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
          gc = event.gc
          gcs_reset gc
          unless @obj.dsl.hidden
            gc.set_antialias ::Swt::SWT::ON
            gc.set_line_cap(LINECAP[@obj.dsl.style[:cap]] || LINECAP[:rect])
            gc.set_transform(@obj.transform)
            obj = @obj.dsl
            case obj
            when ::Shoes::Oval, ::Shoes::Rect
              set_rotate gc, @obj.angle, obj.left+obj.width/2.0, obj.top+obj.height/2.0 do
                fill gc if fill_setup(gc)
                draw gc if draw_setup(gc)
              end
            else
              fill gc if fill_setup(gc)
              draw gc if draw_setup(gc)
            end
          end
        end

        # Override in subclass and return something falsy if not using fill
        def fill_setup(gc)
          @obj.apply_fill(gc)
        end

        # Implement in subclass
        def fill(gc)
        end

        # Override in subclass and return something falsy if not using draw
        def draw_setup(gc)
          @obj.apply_stroke(gc)
        end

        # Implement in subclass
        def draw(gc)
        end

        def set_position_and_size
          @obj.left = @obj.dsl.parent.left
          @obj.top = @obj.dsl.parent.top
          @obj.width = @obj.opts[:width] || @obj.dsl.parent.width
          @obj.height = @obj.opts[:height] || @obj.dsl.parent.height
        end

        def set_rotate gc, angle, left, top
          angle, left, top = angle.to_i, left.to_i, top.to_i
          if block_given?
            tr = ::Swt::Transform.new Shoes.display
            reset_rotate tr, gc, angle, left, top
            yield
            reset_rotate tr, gc, -angle, left, top
          end
        end

        def reset_rotate tr, gc, angle, left, top
          tr.translate left, top
          tr.rotate angle
          tr.translate -left, -top
          gc.setTransform tr
        end
      end
    end
  end
end
