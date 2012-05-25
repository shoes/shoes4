require 'hpricot'

class Comic
  attr_reader :rss, :title

  def initialize(body)
    @rss = Hpricot.XML(body)
    @title = @rss.at("//channel/title").inner_text
  end

  def items
    @rss.search("//channel/item")
  end

  def latest_image
    @rss.search("//channel/item").first.inner_html.scan(/src="([^"]+\.\w+)"/).first
  end
end

Shoes.app :width => 800, :height => 600 do
  background "#555"

  @title = "Web Funnies"
  @feeds = [
    "http://xkcd.com/rss.xml",
    "http://feedproxy.google.com/DilbertDailyStrip?format=xml",
    "http://www.smbc-comics.com/rss.php",
    "http://www.daybydaycartoon.com/index.xml",
    "http://www.questionablecontent.net/QCRSS.xml",
    "http://indexed.blogspot.com/feeds/posts/default?alt=rss"
    ]

  stack :margin => 10 do
    title strong(@title), :align => "center", :stroke => "#DFA", :margin => 0
    para "(loaded from RSS feeds)", :align => "center", :stroke => "#DFA",
      :margin => 0

    @feeds.each do |feed|
      download feed do |dl|
        stack :width => "100%", :margin => 10, :border => 1 do
          c = Comic.new dl.response.body
          stack :margin_right => gutter do
            background "#333", :curve => 4
            caption c.title, :stroke => "#CD9", :margin => 4
          end
          image c.latest_image.first, :margin => 8
        end
      end
    end
  end
end
