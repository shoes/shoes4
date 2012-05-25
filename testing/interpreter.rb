require '../lib/shoes'
java_import 'org.jruby.embed.ScriptingContainer'
java_import 'org.jruby.embed.LocalVariableBehavior'
java_import 'org.jruby.embed.LocalContextScope'



Shoes.app do
  container = ScriptingContainer.new(LocalContextScope::SINGLETHREAD, LocalVariableBehavior::PERSISTENT);
  
  stack do
    mainbox = text_box :id => 'textbox',:width => 80, :scroll => true, :bottom => true
    num = @elements['textbox'].getRows()
    
    (num-1).times do
      mainbox.append("Hepcat>\n")
      
    end
    flow do
      prompt = edit_line :id => 'prompt', :width => 300
      button :text=>"Send", :id => 'enterbutton' do
        mainbox.append("Hepcat>"+@elements['prompt'].getText()+"\n")
        mainbox.append("=>"+container.runScriptlet(@elements['prompt'].getText()).to_s+"\n")
      end
    end
  end
  
  
end

