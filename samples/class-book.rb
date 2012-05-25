require 'yaml'

class Book < Shoes
  url '/', :index
  url '/incidents/(\d+)', :incident

  def index
    incident(0)
  end

  INCIDENTS = YAML.load_file('class-book.yaml')

  def table_of_contents
    toc = []
    INCIDENTS.each_with_index do |(title, story), i|
      toc.push "(#{i + 1}) ",
        link(title, :click => "/incidents/#{i}"),
        " / "
    end
    toc.pop
    span *toc
  end

  def incident(num)
    num = num.to_i
    background white
    stack :margin => 10, :margin_left => 190, :margin_top => 20 do
      banner "Incident", :margin => 4
      para strong("No. #{num + 1}: #{INCIDENTS[num][0]}"), :margin => 4
    end
    flow :width => 180, :margin_left => 10, :margin_top => 0 do
      para table_of_contents, :size => 8
    end
    stack :width => -190, :margin => 10, :margin_top => 0 do
      INCIDENTS[num][1].split(/\n\n+/).each do |p|
        para p
      end
    end
  end
end

Shoes.app :width => 640, :height => 700,
  :title => "Incidents, a Book"
