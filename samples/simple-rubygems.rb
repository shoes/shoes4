#
# The setup block will install gems before launching the 
# rest of the app below it.
#
Shoes.setup do
  gem 'bluecloth =2.0.6'
  gem 'metaid'
end

require 'bluecloth'
require 'metaid'

Shoes.app :width => 300, :height => 400, :resizable => false do
  background "#eed"

  stack :margin => 40 do
    tagline "Loaded Gems:", :align => "center", :underline => "single"
    Gem.loaded_specs.each do |name, spec|
      para "#{name}\n#{spec.version}", :align => "center"
    end

    caption "Total Gems: #{Gem.source_index.length}", :align => "center", :margin_bottom => 0
    para "(includes unloaded gems)", :align => "center", :margin_top => 0
    button "OK", :bottom => 30, :left => 0.4 do
      self.close
    end
  end

end
