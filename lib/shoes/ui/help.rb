require 'nokogiri'
require 'nkf'
require 'ext/highlighter'

class Array
  def / len
    a = []
    each_with_index do |x, i|
      a << [] if i % len == 0
      a.last << x
    end
    a
  end

  def dark?
    r, g, b = self
    r + g + b < 0x55 * 3
  end

  def light?
    r, g, b = self
    r + g + b > 0xAA * 3
  end
end

class Manual < Shoes
  url '/', :index
  url '/manual/(\d+)', :index

  include HH::Markup

  def index pnum = 0
    #font LANG == 'ja' ? 'MS UI Gothic' : 'Arial'
    #style Link, underline: false, weight: 'bold'
    #style LinkHover, stroke: '#06E'
    self.scroll_top = 0
    TOC.clear; TOC_LIST.clear
    table_of_contents.each{|toc| TOC << toc}
    pnum == '999' ? mk_search_page : manual( *get_title_and_desc(pnum.to_i) )
  end

  def get_title_and_desc pnum
    chapter, section = PNUMS[pnum]
    return nil unless chapter
    if section
      [pnum, DOCS[chapter][1][:sections][section][1][:title],
      DOCS[chapter][1][:sections][section][1][:description],
      DOCS[chapter][1][:sections][section][1][:methods]]
    else
      [pnum, DOCS[chapter][0], DOCS[chapter][1][:description], []]
    end
  end

  def table_of_contents
    PNUMS.map.with_index do |e, pnum|
      chapter, section = e
      title = section ? DOCS[chapter][1][:sections][section][1][:title] : DOCS[chapter][0]
      title = title.sub('The', '').split(' ').first
      TOC_LIST << [title, section]
      section ? ['   ', link(title){visit "/manual/#{pnum}"}, "\n"] : [link(fg(title, magenta)){visit "/manual/#{pnum}"}, "\n"]
    end.flatten
  end

  def manual pnum, docs_title, docs_description, docs_methods
    flow do
      show_header docs_title
      show_toc
      paras = mk_paras docs_description
      flow width: 0.75, margin: [20, 0, 20, 0] do
        show_page paras, true
        show_methods docs_methods
        para link('top'){visit "/manual/0"}, "  ",
          link('prev'){visit "/manual/#{(pnum-1)%PEND}"}, "  ",
          link('next'){visit "/manual/#{(pnum+1)%PEND}"}, "  ",
          link('end'){visit "/manual/#{PEND-1}"}
      end
    end
  end

  def show_header docs_title
    background snow..white, angle: 90
    background midnightblue..black, height: 90
    flow width: 500 do
      para fg("The Shoes 4 Manual #{VERSION}", gray), left: 120, top: 10
      title fg(docs_title, white), left: 120, top: 30, font: 'Coolvetica'
    end
    image(File.join(DIR, 'static/shoes-icon.png'), width: 110, height: 110).move 5, -12
  end

  def show_toc
    s = self
    stack height: 30
    flow width: 0.2, margin_left: 10 do
      flow(margin_right: 20) do
        background black(0.7), curve: 5
        inscription "Not findng it?\n", 'Try ', link(fg 'Search', white){visit '/manual/999'}, '!', align: 'center', stroke: lightgray
      end
      stack(height: 10){}
      para *TOC
      para link(fg 'to_html', green){s.html_manual}
    end
  end

  def show_methods docs_methods, term = nil
    docs_methods.each do |m, d|
      flow do
        background rgb(60, 60, 60), curve: 5
        n = m.index("\u00BB")
        if n
          para '  ', fg(strong(m[0...n]), white), fg(strong(m[n..-1]), rgb(160, 160, 160))
        else
          para '  ', fg(strong(m), white)
        end
      end
      para NL
      show_page mk_paras(d), false, term
    end
  end

  def show_page paras, intro = false, term = nil
    s = self
    paras.each_with_index do |text, i|
      if text =~ CODE_RE
        text.gsub CODE_RE do |lines|
          lines = lines.split NL
          n = lines[1] =~ /\#\!ruby/ ? 2 : 1
          _code = lines[n...-1].join(NL+'  ')
          flow do
            background rgb(190, 190, 190), curve: 5
            inscription link(fg('Run this', magenta)){eval s.mk_executable(_code), TOPLEVEL_BINDING}, '  ', align: 'right'
            if _code.include? 'te-su-to'
              para fg(code('  ' + _code), maroon), NL, margin: [-10, 10, 0, 20]
            else
              para *highlight('  ' + _code, nil).map{|e| code e}, NL * 2, margin: [-10, 10, 0, 20]
            end
          end
          fill_rest_of_line
          para NL
        end
        next
      end

      if text =~ /\A \* (.+)/m
        $1.split(/^ \* /).each do |txt|
          image File.join(DIR, 'static/shoes-icon.png'), width: 20, height: 20
          flow(width: 510){show_paragraph txt, intro, i, term}
          para NL
        end
      else
        show_paragraph text, intro, i, term
      end
    end
  end

  def show_paragraph txt, intro, i, term = nil
    txt = txt.gsub("\n", ' ').gsub(/\^(.+?)\^/m, '\1').gsub(/\[\[BR\]\]/i, "\n")
    txts = txt.split(/(\[\[\S+?\]\])/m).map{|s| s.split(/(\[\[\S+? .+?\]\])/m)}.flatten
    case txts[0]
    when /\A==== (.+) ====/; caption *marker($1, term), size: 24
    when /\A=== (.+) ===/; tagline *marker($1, term), size: 12, weight: 'bold'
    when /\A== (.+) ==/; subtitle *marker($1, term)
    when /\A= (.+) =/; title *marker($1, term)
    when /\A\{COLORS\}/; flow{color_page}
    when /\A\{SAMPLES\}/; flow{sample_page}
    else
      para *mk_deco(mk_links(txts, term).flatten), NL, (intro and i.zero?) ? {size: 16} : ''
      txt.gsub IMAGE_RE do
        image File.join(DIR, "static/#{$3}"), eval("{#{$2 or "margin_left: 50"}}")
        fill_rest_of_line
      end
    end
  end

  def mk_links txts, term = nil
    txts.map{|txt| txt.gsub(IMAGE_RE, '')}.
      map{|txt| txt =~ /\[\[(\S+?)\]\]/m ? (t = $1.split('.'); link(ins *marker(t.last, term)){visit "/manual/#{find_pnum t.first}"}) : txt}.
      map{|txt| txt =~ /\[\[(\S+?) (.+?)\]\]/m ? (url = $1; link(ins *marker($2, term)){visit url =~ /^http/ ? url : "/manual/#{find_pnum url}"}) :
      (txt.is_a?(String) ? marker(txt, term) : txt)}
  end

  def mk_paras str
    str.split(PARA_RE) - ['']
  end

  def mk_executable code
    if code =~ /\# Not yet available/
      "Shoes.app{para 'Sorry, not yet available...'}"
    else
      code
    end
  end

  def color_page
    COLORS.each do |color, v|
      r, g, b = v.red, v.green, v.blue
      c = v.dark? ? white : black
      stack width: 0.33, height: 55, margin_top: 5 do
        clr = send(color)
        background clr
        #para fg(strong(color), c), align: 'center'
        para fg('. ', clr), fg(strong(color), c), fg(' .', clr), align: 'center'
        para fg("rgb(#{r}, #{g}, #{b})", c), align: 'center'
      end
    end
    para NL
  end

  def sample_page
    mk_sample_names.each do |file|
      stack width: 80 do
        inscription file[0...-3]
        image File.join(DIR, "snapshots/#{file[0..-3]}png"), width: 50, height: 50 do
          Dir.chdir(File.join DIR, 'samples'){instance_eval(IO.read(file),file,0)}
        end
        para NL
      end
    end
  end

  def mk_sample_names
    Dir[File.join(DIR, 'samples/sample*.rb')].map do |file|
      orig_name = File.basename file
      dummy_name = orig_name.sub(/sample(.*)\.rb/){
        first, second = $1.split('-')
        "%02d%s%s" % [first.to_i, ('-' if second), second]
      }
      [dummy_name, orig_name]
    end.sort.map &:last
  end

  def find_pnum page
    return 999 if page == 'Search'
    TOC_LIST.each_with_index do |e, i|
      title, section = e
      return i if title == page
    end
  end

  def self.load_docs path
    str = IO.read(path).force_encoding("UTF-8")
    (str.split(/^= (.+?) =/)[1..-1]/2).map do |k, v|
      sparts = v.split(/^== (.+?) ==/)
      sections = (sparts[1..-1]/2).map do |k2, v2|
        meth = v2.split(/^=== (.+?) ===/)
        k2t = k2[/^(?:The )?([\-\w]+)/, 1]
        meth_plain = meth[0].gsub(IMAGE_RE, '')
        h = {title: k2, section: k, description: meth[0], methods: (meth[1..-1]/2)}
        [k2t, h]
      end
      h = {description: sparts[0], sections: sections, class: "toc" + k.downcase.gsub(/\W+/, '')}
      [k, h]
    end
  end

  def self.mk_page_numbers docs
    pnum = []
    docs.length.times do |i|
      pnum << [i, nil]
      docs[i][1][:sections].length.times do |j|
        pnum << [i, j]
      end
    end
    pnum
  end

  def html_manual
    dir = ask_save_folder
    return unless dir
    FileUtils.mkdir_p File.join(dir, 'static')
    FileUtils.mkdir_p File.join(dir, 'snapshots')
    %w[shoes-icon.png shoes-manual-apps.png manual.css code_highlighter.js code_highlighter_ruby.js].
      each{|x| FileUtils.cp "#{DIR}/static/#{x}", "#{dir}/static"}
    Dir[File.join DIR, 'static/man-*.png'].each{|x| FileUtils.cp x, "#{dir}/static"}
    Dir[File.join DIR, 'snapshots/sample*.png'].each{|x| FileUtils.cp x, "#{dir}/snapshots"}

    TOC_LIST.length.times do |n|
      num, title, desc, methods = get_title_and_desc n
      open File.join(dir, "#{TOC_LIST[n][0]}.html"), 'wb:utf-8' do |f|
        html = mk_html(title, desc, methods, TOC_LIST[n+1], get_title_and_desc(n+1), mk_sidebar_list(num))
        f.puts html.force_encoding('UTF-8')
      end
    end
  end

  def mk_html title, desc, methods, next_file, next_title, menu
    man = self
    html = Nokogiri::HTML::Builder.new do |h|
      h.html(:lang => Manual::LANG) do
        h.head do
          h.meta charset: 'utf-8'
          h.title "The Shoes 4 Manual // #{title}"
          h.script type: "text/javascript", src: "static/code_highlighter.js"
          h.script type: "text/javascript", src: "static/code_highlighter_ruby.js"
          h.style type: "text/css" do
            h.text "@import 'static/manual.css';"
          end
        end
        h.body do
          h.div.main! do
            h.div.manual! do
              h.h2 "The Shoes 4 Manual #{VERSION}"
              h.h1 title

              paras = man.mk_paras desc
              h.div(:class => 'intro') { h << man.manual_p(paras.shift) }

              html_paragraph = proc do
                paras.each do |str|
                  if str =~ CODE_RE
                    h.pre{h.code(class: 'rb'){h.text $1.gsub(/^\s*?\n/, '')}}
                  else
                    cmd, str = case str
                      when /\A==== (.+) ====/; [:h4, $1]
                      when /\A=== (.+) ===/; [:h3, $1]
                      when /\A== (.+) ==/; [:h2, $1]
                      when /\A= (.+) =/; [:h1, $1]
                      when /\A\{COLORS\}/
                        COLORS.each do |color, v|
                          f = v.dark? ? "white" : "black"
                          h.div(class: 'color', style: "background: #{color}; color: #{f}"){ h.h3 color.to_s; h.p("rgb(%d, %d, %d)" % [v.red, v.green, v.blue])}
                        end
                      when /\A\{SAMPLES\}/
                        man.mk_sample_names.each do |name|
                          name = name[0...-3]
                          h.div( :class => 'sample') do
                            h.h3 name
                            h.text '<a href="snapshots/%s.png"><img src="snapshots/%s.png" alt="%s" border=0 width=50 height=50></a>' % [name, name, name]
                          end
                        end
                      when /\A \* (.+)/m
                        h.ul {$1.split(/^ \* /).each{|x| h << man.manual_p(x) }} ; nil
                      else
                        [:p_, str]
                      end
                    h.send(cmd){ h << man.manual_p(str) } if cmd.is_a?(Symbol)
                  end
                end
              end

              html_paragraph.call

              methods.each do |m, d|
                n = m.index("\u00BB")
                n ? (sig, val = m[0...n-1], m[n-1..-1]) : (sig, val = m, nil)
                aname = sig[/^[^(=]+=?/].gsub(/\s/, '').downcase
                h.a(name: aname)
                h.div(class: 'divmethod') do
                  h.a sig, href: "##{aname}"
                  h.text val if val
                end
                h.div(class: 'desc') do
                  paras = man.mk_paras d
                  html_paragraph.call
                end
              end

              h.p(class: 'next'){h.text "Next: "; h.a(href: "#{next_file[0]}.html") { h.text next_title[1] }} if next_title
            end
            h.div(class: 'sidebar') do
              h.img src: "static/shoes-icon.png"
              h.ul do
                h.li{h.a(class:'prime', href: "./") { h.text "HELP" }}
                menu.each do |m|
                  h.li do
                    unless m.is_a?(Array)
                      h.a(href: "#{m}.html") {h.text m}
                      else
                        h.ul(class: 'sub') do
                        m.each do |sm|
                          h.li{h.a(href: "#{sm}.html") {h.text sm}}
                        end
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

    "<!DOCTYPE html>\n#{html}"
  end

  def mk_sidebar_list num
    toc = []
    [0..3, 4..9, 10..16, 17..32, 33..37].each do |r|
      toc.push TOC_LIST[r.first][0]
      toc.push(TOC_LIST[r.first+1..r.last].to_a.map &:first) if r.include?(num)
    end
    toc
  end

  def manual_p str
    str.gsub(/\n+\s*/, " ").
      gsub(/&/, '&amp;').gsub(/>/, '&gt;').gsub(/>/, '&lt;').gsub(/"/, '&quot;').
      gsub(/`(.+?)`/m, '<code>\1</code>').gsub(/\[\[BR\]\]/i, "<br />\n").
      gsub(/\^(.+?)\^/m, '\1').
      gsub(/'''(.+?)'''/m, '<strong>\1</strong>').gsub(/''(.+?)''/m, '<em>\1</em>').
      gsub(/\[\[((http|https):\/\/\S+?)\]\]/m, '<a href="\1" target="_new">\1</a>').
      gsub(/\[\[((http|https):\/\/\S+?) (.+?)\]\]/m, '<a href="\1" target="_new">\3</a>').
      gsub(/\[\[(\S+?)\]\]/m) do
        ms, mn = $1.split(".", 2)
        if mn
          '<a href="' + ms + '.html#' + mn + '">' + mn + '</a>'
        else
          '<a href="' + ms + '.html">' + ms + '</a>'
        end
      end.
      gsub(/\[\[(\S+?) (.+?)\]\]/m, '<a href="\1.html">\2</a>').
      gsub(/\!(\{[^}\n]+\})?([^!\n]+\.\w+)\!/) do
        '<img src="' + "static/#$2" + '" />'
      end
  end

  def mk_search_page
    s = self
    flow do
      show_header 'Search'
      show_toc
      pnum, docs_title, docs_description, docs_methods = get_title_and_desc(25)
      paras = mk_paras docs_description

      flow width: 0.8, margin: [10, 0, 20, 0] do
        el = edit_line width: 300
        tagline link('search'){
          term = el.text.strip
          unless term.empty?
            descs, methods = s.search term
            @f.clear{s.show_search_result term, descs, methods}
          end
        }
        stack(height: 20){}
        @f = flow{}
      end
    end
  end

  def search term
    descs, methods = [], []
    PNUMS.each_with_index do |(chapter, section), pnum|
      pnum, docs_title, docs_description, docs_methods = get_title_and_desc(pnum)
      paras = mk_paras(docs_description)
      descs << [chapter, section, docs_title, paras] if paras.map{|txt| txt.gsub(CODE_RE, '').gsub(IMAGE_RE, '')}.join(' ').index(term)
      docs_methods.each do |docs_method|
        m, d = docs_method
        methods << [chapter, section, docs_title, docs_method] if m.index(term) or d.gsub(CODE_RE, '').gsub(IMAGE_RE, '').index(term)
      end
    end
    return descs, methods
  end

  def show_search_result term, descs, methods
    s = self
    if descs.empty? and methods.empty?
      subtitle 'Not Found'
    else
      methods.each do |(chapter, section, docs_title, docs_method)|
        flow margin: [10, 10, 0, 5] do
          background rgb(200, 200, 200), curve: 5
          para "#{DOCS[chapter][0]}: #{docs_title.sub('The', '').split(' ').first}: ",
            link(docs_method[0]){@f.clear{title docs_title; s.show_methods [docs_method], term}}, NL
        end
        stack(height: 2){}
      end
      descs.each do |(chapter, section, docs_title, paras)|
        flow margin_left: 10 do
          if section
            background gray, curve: 5
            tagline link(fg(docs_title, white)){@f.clear{title docs_title; s.show_page paras, true, term}}, width: 320
            inscription "Sub-Section under #{DOCS[chapter][0]}", stroke: lightgray, width: 180
          else
            background black(0.8), curve: 5
            subtitle link(fg(docs_title, white)){@f.clear{title docs_title; s.show_page paras, true, term}}, width: 320
            inscription 'Section Header', stroke: lightgray, width: 100
          end
        end
        stack(height: 2){}
      end
      para NL
    end
  end

  def marker txt, term
    if term && txt
      tmp = txt.split(term).map{|s| [s, bg(term, yellow)]}.flatten
      txt =~ /#{term}$/ ? tmp : tmp[0...-1]
    else
      [txt]
    end
  end

  def mk_deco datas
    datas = decoration(datas, /`(.+?)`/m){|s| fg code(s), rgb(255, 30, 0)}
    datas = decoration(datas, /'''(.+?)'''/m){|s| strong s}
    decoration(datas, /''(.+?)''/m){|s| em s}
  end

  def decoration datas, re, &blk
    datas.map do |data|
      if data.is_a? String
        txts = [data]
        data.match re do |md|
          n = data.index md[0]
          txts = [data[0...n], blk[md[1]], decoration([data[n+md[0].length..-1]], re, &blk)]
        end
        txts
      else
        data
      end
    end.flatten
  end

  # Hack to consume remaining space to the right of a flow.
  # Used to rely on NL's, but with new text flowing, that doesn't work anymore.
  def fill_rest_of_line
    flow width:1.0 do
    end
  end

  IMAGE_RE = /\!(\{([^}\n]+)\})?([^!\n]+\.\w+)\!/
  CODE_RE = /\{{3}(?:\s*\#![^\n]+)?(.+?)\}{3}/m
  PARA_RE = /\s*?(\{{3}(?:.+?)\}{3})|\n\n/m
  NL = "\n"
  LANG = $lang.downcase[0, 2]
  DOCS = load_docs($lang =~ /\.txt$/ ? $lang : File.join(DIR, "static/manual-#{LANG}.txt"))
  PNUMS = mk_page_numbers DOCS
  PEND = PNUMS.length
  TOC, TOC_LIST = [], []
  COLORS = Shoes::COLORS
  VERSION = Shoes::VERSION
end

Shoes.app title: 'The Shoes 4 Manual', width: 720, height: 640
