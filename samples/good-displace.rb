class Layout
  def initialize(app, art, elements)
    @app = app
    @art = art
    @elements = elements
    @position = {}
    @width = 50
    @margin = 10
    @top = 4
  end

  attr_reader :art, :elements, :width, :margin, :top

  def oval
    @app.oval *position(:oval), width
  end

  def rect
    @app.rect *position(:rect), width
  end

  def image
    @app.image File.expand_path(File.join(__FILE__, "../avatar.png")), :left => left(:image), :top => top
  end

  def edit_box
    @app.edit_box "Edit me", :left => left(:edit_box), :top => top, :width => width
  end

  def offset(element)
    art.index(element.to_sym) || elements.index(element.to_sym)
  end

  def left(element)
    (width + margin) * offset(element)
  end

  def position(element)
    [left(element), top]
  end

  def remember(name, element)
    @app.info "Remembering #{name} at [#{element.left}, #{element.top}]"
    @position[name] = [element.left, element.top]
  end

  def recall(name)
    position = @position.fetch(name, "...oops, can't find it...[0, 0]")
    @app.info "Recalling #{name} was at #{position}"
    @position.fetch(name, [0, 0])
  end
end

Shoes.app do
  @art = [:oval, :rect]
  @elements = [:image, :edit_box]
  @objects = {}
  @layout = Layout.new self, @art, @elements
  @create_object = lambda do |name|
    info "#{name} starts at #{@layout.position(name)}"
    @objects[name] = @layout.send(name)
    @layout.remember name, @objects[name]
  end

  stack do
    title "Art"
    flow :height => 100 do
      @art.each &@create_object
    end

    title "Elements"
    flow :height => 100 do
      @elements.each &@create_object
    end

    flow do
      x = 400
      colors = [seagreen, salmon, papayawhip, goldenrod]
      @art.concat(@elements).each_with_index do |name, i|
        stack :width => 100, :margin => 4 do
          background colors[i]
          tagline name.to_s
          button "displace" do
            @layout.remember(name, @objects[name])
            position = [x - @layout.left(name), @layout.top]
            info "#{name} displaces to #{position}"
            @objects[name].displace(*position)
          end
          button "replace" do
            position = @layout.recall(name)
            info "#{name} replaces to #{position}"
            @objects[name].displace(*position)
          end
        end
      end
    end
  end
end
