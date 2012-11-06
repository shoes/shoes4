module Shoes
  module Swt
    module Common
      module Clickable
        def clickable s, blk, flag = :click
          if blk
            ln = ::Swt::Widgets::Listener.new
            s.ln = ln
            s = s.dsl unless s.is_a?(::Shoes::Link) 
            class << ln; self end.
            instance_eval do
              define_method :handleEvent do |e|
                mb, mx, my = e.button, e.x, e.y
                if s.is_a?(::Shoes::Link) #and !s.parent.hidden
                  blk[mb, mx, my] if ((s.pl..(s.pl+s.pw)).include?(mx) and (s.sy..s.ey).include?(my) and !((s.pl..s.sx).include?(mx) and (s.sy..(s.sy+s.lh)).include?(my)) and !((s.ex..(s.pl+s.pw)).include?(mx) and ((s.ey-s.lh)..s.ey).include?(my)))
                elsif !s.is_a?(::Shoes::Link) and !s.hidden
                  blk[mb, mx, my] if s.left <= mx and mx <= s.left + s.width and s.top <= my and my <= s.top + s.height
                end
              end
            end
            s.app.gui.real.addListener ::Swt::SWT::MouseDown, ln if flag == :click
            s.app.gui.real.addListener ::Swt::SWT::MouseUp, ln if flag == :release
          end
        end
        
        def click &blk
          clickable self, blk, :click
        end
    
        def release &blk
          clickable self, blk, :release
        end
      end
    end
  end
end
