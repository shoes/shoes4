require 'yaml'

class Book < Shoes
  url '/', :index
  url '/incidents/(\d+)', :incident

  def index
    incident 0
  end

  INCIDENTS = YAML.load_file File.expand_path(File.join(__FILE__, '../class-book.yaml'))

  def table_of_contents
    toc = []
    INCIDENTS.each_with_index do |(title, _story), i|
      toc.push "(#{i + 1}) ",
               link(title) { visit "/incidents/#{i}" },
               " / "
    end
    toc[0...-1] << "\n" * 5
  end

  def incident(num)
    self.scroll_top = 0
    num = num.to_i
    stack margin_left: 200 do
      banner "Incident", margin: [0, 10, 0, 30]
      para strong("No. #{num + 1}: #{INCIDENTS[num][0]}"), margin_bottom: 5
    end

    flow do
      flow width: 180, margin_left: 10 do
        para(*table_of_contents, size: 8)
      end

      stack width: width - 180, margin: [20, 0, 10, 0] do
        INCIDENTS[num][1].split(/\n\n+/).each do |p|
          para p
        end
      end
    end
  end
end

Shoes.app width: 640, height: 700, title: "Incidents, a Book"
