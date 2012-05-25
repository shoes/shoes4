Shoes.app :title => "Dictionary, powered by Definr", :width => 370, :height => 320 do
  stack do
    background red, :height => 60
    flow :margin => 20 do
      caption "Define: ", :stroke => white
      @lookup = edit_line
      button "Go" do
        download "http://definr.com/definr/show/#{@lookup.text}" do |dl|
          doc = dl.response.body.gsub('&nbsp;', ' ').
              gsub(%r!(</a>|<br />|<a href.+?>)!, '').
              gsub(%r!\(http://.+?\)!, '').strip
          title, doc = doc.split(/\n+/, 2)
          @deft.replace title
          @defn.replace doc
        end
      end
    end
    stack :margin => 20 do
      @deft = subtitle "", :margin => 10
      @defn = para ""
    end
  end
end
