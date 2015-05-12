# -*- encoding: utf-8 -*-
module Shoes::Manual
  PARA_RE = /\s*?(\{{3}(?:.+?)\}{3})|\n\n/m
  CODE_RE = /\{{3}(?:\s*\#![^\n]+)?(.+?)\}{3}/m
  IMAGE_RE = /\!(\{([^}\n]+)\})?([^!\n]+\.\w+)\!/
  CODE_STYLE = {:size => 9, :margin => 12}
  INTRO_STYLE = {:size => 16, :margin_bottom => 20, :stroke => "#000"}
  SUB_STYLE = {:stroke => "#CCC", :margin_top => 10}
  IMAGE_STYLE = {:margin => 8, :margin_left => 100}
  COLON = ": "

  [INTRO_STYLE, SUB_STYLE].each do |h|
    h[:font] = "MS UI Gothic"
  end if Shoes.language == 'ja'

  def self.path
    path = "#{DIR}/static/manual-#{Shoes.language}.txt"
    unless File.exist? path
      path = "#{DIR}/static/manual-en.txt"
    end
    path
  end

  def dewikify_hi(str, terms, intro = false)
    if terms
      code = []
      str = str.
        gsub(CODE_RE) { |x| code << x; "CODE#[#{code.length-1}]" }.
        gsub(/#{Regexp::quote(terms)}/i, '@\0@').
        gsub(/CODE#\[(\d+)\]/) { code[$1.to_i] }
    end
    dewikify(str, intro)
  end

  def dewikify_p(ele, str, *args)
    str = str.gsub(/\n+\s*/, " ").dump.
      gsub(/`(.+?)`/m, '", code("\1"), "').gsub(/\[\[BR\]\]/i, "\n").
      gsub(/\^(.+?)\^/m, '\1').
      gsub(/@(.+?)@/m, '", strong("\1", :fill => yellow), "').
      gsub(/'''(.+?)'''/m, '", strong("\1"), "').gsub(/''(.+?)''/m, '", em("\1"), "').
      gsub(/\[\[(\S+?)\]\]/m, '", link("\1".split(".", 2).last) { open_link("\1") }, "').
      gsub(/\[\[(\S+?) (.+?)\]\]/m, '", link("\2") { open_link("\1") }, "').
      gsub(IMAGE_RE, '", *args); stack(IMAGE_STYLE.merge({\2})) { image("#{DIR}/static/\3") }; #{ele}("')
    #debug str if str =~ /The list of special keys/
    a = str.split(', ", ", ')
    if a.size == 1
      eval("#{ele}(#{str}, *args)")
    else
      flow do
        a[0...-1].each{|s| eval("#{ele}(#{s}, ',', *args)")}
        eval("#{ele}(#{a[-1]}, *args)")
      end
    end
  end

  def dewikify_code(str)
    str = str.gsub(/\A\n+/, '').chomp
    stack :margin_bottom => 12 do
      background rgb(210, 210, 210), :curve => 4
      para code(str), CODE_STYLE
      stack :top => 0, :right => 2, :width => 70 do
        stack do
          background "#8A7", :margin => [0, 2, 0, 2], :curve => 4
          para link("Run this", :stroke => "#eee", :underline => "none") { run_code(str) },
            :margin => 4, :align => 'center', :weight => 'bold', :size => 9
        end
      end
    end
  end

  def wiki_tokens(str, intro = false)
    paras = str.split(PARA_RE).reject { |x| x.empty? }
    if intro
      yield :intro, paras.shift
    end
    paras.map do |ps|
      if ps =~ CODE_RE
        yield :code, $1
      else
        case ps
        when /\A\{COLORS\}/
          yield :colors, nil
        when /\A\{INDEX\}/
          yield :index, nil
        when /\A\{SAMPLES\}/
          yield :samples, nil
        when /\A \* (.+)/m
          yield :list, $1.split(/^ \* /)
        when /\A==== (.+) ====/
          yield :caption, $1
        when /\A=== (.+) ===/
          yield :tagline, $1
        when /\A== (.+) ==/
          yield :subtitle, $1
        when /\A= (.+) =/
          yield :title, $1
        else
          yield :para, ps
        end
      end
    end
  end

  def dewikify(str, intro = false)
    proc do
      wiki_tokens(str, intro) do |sym, text|
        case sym when :intro
          dewikify_p :para, text, INTRO_STYLE
        when :code
          dewikify_code(text)
        when :colors
          color_page
        when :index
          index_page
        when :samples
          sample_page
        when :list
          text.each { |t| stack(:margin_left => 30) {
            fill black; oval(-10, 7, 6); dewikify_p :para, t } }
        else
          dewikify_p sym, text
        end
      end
    end
  end

  def sample_page
    folder = File.join DIR, 'samples'
    h = {}
    Dir.glob(File.join folder, '*').each do |file|
      if File.extname(file) == '.rb'
        key = File.basename(file).split('-')[0]
        h[key] ? h[key].push(file) : h[key] = [file]
      end
    end
    stack do
      h.each do |k, v|
        subtitle k
        flow do
          v.each do |file|
            para link(File.basename(file).split('-')[1..-1].join('-')[0..-4]){
              Dir.chdir(folder){eval IO.read(file).force_encoding("UTF-8"), TOPLEVEL_BINDING}
            }
          end
        end
      end
    end
  end

  def color_page
    color_names = (Shoes::COLORS.keys*"\n").split("\n").sort
    flow do
      color_names.each do |color|
        flow :width => 0.33 do
          c = send(color)
          background c
          para strong(color), "\n", c, :stroke => (c.dark? ? white : black),
            :margin => 4, :align => 'center'
        end
      end
    end
  end

  def class_tree
    tree = {}
    Shoes.constants.each do |c|
      k = Shoes.const_get(c)
      next unless k.respond_to? :superclass

      c = "Shoes::#{c}"
      if k.superclass == Object
        tree[c] ||= []
      else
        k.ancestors[1..-1].each do |sk|
          break if [Object, Kernel].include? sk
          next unless sk.is_a? Class #don't show mixins
          (tree[sk.name] ||= []) << c
          c = sk.name
        end
      end
    end
    tree
  end

  def index_page
    tree = class_tree
    shown = []
    index_p = proc do |k, subs|
      unless shown.include? k
        stack :margin_left => 20 do
          flow do
            para "▸ ", :font => case RUBY_PLATFORM
              when /mingw/  then "MS UI Gothic"
              when /darwin/ then "AppleGothic, Arial"
              else "Arial"
              end
            para k
          end
          subs.uniq.sort.each do |s|
            index_p[s, tree[s]]
          end if subs
        end
        shown << k
      end
    end
    tree.sort.each(&index_p)
  end

  def run_code str
    eval(str, TOPLEVEL_BINDING)
  end

  def load_docs path
    return @docs if @docs
    str = Shoes.read_file(path)
    @search = Shoes::Search.new
    @sections, @methods, @mindex = {}, {}, {}
    @docs =
      (str.split(/^= (.+?) =/)[1..-1]/2).map do |k,v|
        sparts = v.split(/^== (.+?) ==/)

        sections = (sparts[1..-1]/2).map do |k2,v2|
          meth = v2.split(/^=== (.+?) ===/)
          k2t = k2[/^(?:The )?([\-\w]+)/, 1]
          meth_plain = meth[0].gsub(IMAGE_RE, '')
          @search.add_document :uri => "T #{k2t}", :body => "#{k2}\n#{meth_plain}".downcase

          hsh = {'title' => k2, 'section' => k,
            'description' => meth[0],
            'methods' => (meth[1..-1]/2).map { |k3,v3|
              @search.add_document :uri => "M #{k}#{COLON}#{k2t}#{COLON}#{k3}", :body => "#{k3}\n#{v3}".downcase
              @mindex["#{k2t}.#{k3[/[\w\.]+/]}"] = [k2t, k3]
              [k3, v3]
            }
          }
          @methods[k2t] = hsh
          [k2t, hsh]
        end

        @search.add_document :uri => "S #{k}", :body => "#{k}\n#{sparts[0]}".downcase
        hsh = {'description' => sparts[0], 'sections' => sections,
           'class' => "toc" + k.downcase.gsub(/\W+/, '')}
        @sections[k] = hsh
        [k, hsh]
      end
    @search.finish!
    @docs
  end

  def show_search
    @toc.each { |_k,v| v.hide }
    @title.replace "Search"
    @doc.clear do
      dewikify_p :para, "Try method names (like `button` or `arrow`) or topics (like `slots`)", :align => 'center'
      flow :margin_left => 60 do
        edit_line :width => -60 do |terms|
          @results.clear do
            termd = terms.text.downcase
            #found = termd.empty? ? [] : manual_search(termd)
            found = (termd.empty? or termd[0] == 'z' or termd[0] == 'y') ? [] : manual_search(termd)
            para "#{found.length} matches", :align => "center", :margin_bottom => 0
            found.each do |typ, head|
              flow :margin => 4 do
                case typ
                when "S"
                  background "#333", :curve => 4
                  caption strong(link(head, :stroke => white) { open_section(head, terms.text) })
                  para "Section header", Shoes::Manual::SUB_STYLE
                when "T"
                  background "#777", :curve => 4
                  caption strong(link(head, :stroke => "#EEE") { open_methods(head, terms.text) })
                  hsh = @methods[head]
                  para "Sub-section under #{hsh['section']} (#{hsh['methods'].length} methods)", Shoes::Manual::SUB_STYLE
                when "M"
                  background "#CCC", :curve => 4
                  sect, subhead, head = head.split(Shoes::Manual::COLON, 3)
                  para strong(sect, Shoes::Manual::COLON, subhead, Shoes::Manual::COLON, link(head) { open_methods(subhead, terms.text, head) })
                end
              end
            end
          end
        end
      end
      @results = stack
    end
    app.slot.scroll_top = 0
  end

  def open_link(head)
    if head == "Search"
      show_search
    elsif @sections.has_key? head
      open_section(head)
    elsif @methods.has_key? head
      open_methods(head)
    elsif @mindex.has_key? head
      head, sub = @mindex[head]
      open_methods(head, nil, sub)
    elsif head =~ /^http:\/\//
      debug head
      visit head
    end
  end

  def add_next_link(docn, optn)
    opt1, optn = @docs[docn][1], optn + 1
    if opt1['sections'][optn]
      @doc.para "Next: ",
        link(opt1['sections'][optn][1]['title']) { open_methods(opt1['sections'][optn][0]) },
        :align => "right"
    elsif @docs[docn + 1]
      @doc.para "Next: ",
        link(@docs[docn + 1][0]) { open_section(@docs[docn + 1][0].gsub(/\W/, '')) },
        :align => "right"
    end
  end

  def open_section(sect_s, terms = nil)
    sect_h = @sections[sect_s]
    sect_cls = sect_h['class']
    @toc.each { |k,v| v.send(k == sect_cls ? :show : :hide) }
    @title.replace sect_s
    @doc.clear(&dewikify_hi(sect_h['description'], terms, true))
    add_next_link(@docs.index { |x| x == sect_s }, -1) rescue nil
    app.slot.scroll_top = 0
  end

  def open_methods(meth_s, terms = nil, meth_a = nil)
    meth_h = @methods[meth_s]
    @title.replace meth_h['title']
    @doc.clear do
      unless meth_a
        instance_eval(&dewikify_hi(meth_h['description'], terms, true))
      end
      meth_h['methods'].each do |mname, expl|
        if meth_a.nil? or meth_a == mname
          sig, val = mname.split("»", 2)
          stack(:margin_top => 8, :margin_bottom => 8) {
            background "#333".."#666", :curve => 3, :angle => 90
            tagline sig, (span("»", val, :stroke => "#BBB") if val), :margin => 4 }
          instance_eval(&dewikify_hi(expl, terms))
        end
      end
    end
    optn = nil
    docn = @docs.index { |_,h| optn = h['sections'].index { |x| x == meth_s } } rescue nil
    add_next_link(docn, optn) if docn
    app.slot.scroll_top = 0
  end

  def manual_search(terms)
    terms += " " if terms.length == 1
    @search.find_all(terms).map do |title|
      title.split(" ", 2)
    end
  end

  def make_html(path, title, menu, &blk)
    require 'hpricot'
    File.open(path, 'w') do |f|
      f << Hpricot do
        xhtml_transitional do
          head do
            meta :"http-equiv" => "Content-Type", "content" => "text/html; charset=utf-8"
            title "The Shoes Manual // #{title}"
            script :type => "text/javascript", :src => "static/code_highlighter.js"
            script :type => "text/javascript", :src => "static/code_highlighter_ruby.js"
            style :type => "text/css" do
              text "@import 'static/manual.css';"
            end
          end
          body do
            div.main! do
              div.manual!(&blk)
              div.sidebar do
                img :src => "static/shoes-icon.png"
                ul do
                  li { a.prime "HELP", :href => "./" }
                  menu.each do |m, sm|
                    li do
                      a m, :href => "#{m[/^\w+/]}.html"
                      if sm
                        ul.sub do
                          sm.each { |smm| li { a smm, :href => "#{smm}.html" } }
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end.to_html
    end
  end
end

def Shoes.make_help_page
  font "#{DIR}/fonts/Coolvetica.ttf" unless Shoes::FONTS.include? "Coolvetica"
  proc do
    extend Shoes::Manual
    docs = load_docs Shoes::Manual.path

    style(Shoes::Image, :margin => 8, :margin_left => 100)
    style(Shoes::Code, :stroke => "#C30")
    style(Shoes::LinkHover, :stroke => green, :fill => nil)
    style(Shoes::Para, :size => 12, :stroke => "#332")
    style(Shoes::Tagline, :size => 12, :weight => "bold", :stroke => "#eee", :margin => 6)
    style(Shoes::Caption, :size => 24)
    background "#ddd".."#fff", :angle => 90

    [Shoes::LinkHover, Shoes::Para, Shoes::Tagline, Shoes::Caption].each do |type|
      style(type, :font => "MS UI Gothic")
    end if Shoes.language == 'ja'

    stack do
      background black
      stack :margin_left => 118 do
        para "The Shoes Manual", :stroke => "#eee", :margin_top => 8, :margin_left => 17,
          :margin_bottom => 0
        @title = title docs[0][0], :stroke => white, :margin => 4, :margin_left => 14,
          :margin_top => 0, :font => "Coolvetica"
      end
      background "rgb(66, 66, 66, 180)".."rgb(0, 0, 0, 0)", :height => 0.7
      background "rgb(66, 66, 66, 100)".."rgb(255, 255, 255, 0)", :height => 20, :bottom => 0
    end
    @doc =
      stack :margin_left => 130, :margin_top => 20, :margin_bottom => 50, :margin_right => 50 + gutter,
        &dewikify(docs[0][-1]['description'], true)
    add_next_link(0, -1)
    stack :top => 80, :left => 0, :attach => Shoes::Window do
      @toc = {}
      stack :margin => 12, :width => 130, :margin_top => 20 do
        docs.each do |sect_s, sect_h|
          sect_cls = sect_h['class']
          para strong(link(sect_s, :stroke => black) { open_section(sect_s) }),
            :size => 11, :margin => 4, :margin_top => 0
          @toc[sect_cls] =
            stack :hidden => @toc.empty? ? false : true do
              links = sect_h['sections'].map do |meth_s|
                [link(meth_s) { open_methods(meth_s) }, "\n"]
              end.flatten
              links[-1] = {:size => 9, :margin => 4, :margin_left => 10}
              para(*links)
            end
        end
      end
      stack :margin => 12, :width => 118, :margin_top => 6 do
        background "#330", :curve => 4
        para "Not finding it? Try ", strong(link("Search", :stroke => white) { show_search }), "!", :stroke => "#ddd", :size => 9, :align => "center", :margin => 6
      end
      stack :margin => 12, :width => 118 do
        inscription "Shoes #{Shoes::RELEASE_NAME}\nRevision: #{Shoes::REVISION}",
          :size => 7, :align => "center", :stroke => "#999"
      end
    end
    image :width => 120, :height => 120, :top => -18, :left => 6 do
      image "#{DIR}/static/shoes-icon.png", :width => 100, :height => 100, :top => 10, :left => 10
      glow 2
    end
  end
rescue => e
  p e.message
  p e.class
end


Shoes::Help = Shoes.make_help_page

# added to start the app, was Shoes.manual_as :shoes
Shoes.app(:width => 720, :height => 640, &Shoes::Help)
