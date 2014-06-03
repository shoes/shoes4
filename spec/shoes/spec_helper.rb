require 'spec_helper'

def it_styles_with(*styles)
  #unpack styles 
  supported_styles = []
    styles.each do |style|
      if Shoes::Common::Style::STYLE_GROUPS[style]
        Shoes::Common::Style::STYLE_GROUPS[style].each{|style| supported_styles << style}
      else
        supported_styles << style
      end
    end
    
    #check for style behavior
    supported_styles.each do |style|
      it_behaves_like "object that styles with #{style}"
    end
end
