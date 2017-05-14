#! /usr/bin/env ruby
# frozen_string_literal: true

# Lots of setup to get us going, but benchmarks actually kick at the bottom
# Tests out as close to just direct image creation as we can easily get (with
# no painting involved.)

require 'benchmark/ips'
require 'uri'
require 'net/http'
require 'ostruct'

require 'shoes'
require 'shoes/swt'
Shoes::Swt.initialize_backend

SMALL_FILE = File.expand_path(File.join(__FILE__, "..", "small.png"))
SMALLISH_FILE = File.expand_path(File.join(__FILE__, "..", "smallish.png"))
MEDIUM_FILE = File.expand_path(File.join(__FILE__, "..", "medium.jpg"))
LARGE_FILE = File.expand_path(File.join(__FILE__, "..", "large.jpg"))

def check_file(file, url)
  unless File.exist?(file)
    puts "Downloading #{file}..."
    uri = URI.parse(url)
    File.open(file, "w") { |f| f.write(Net::HTTP.get_response(uri).body) }
  end
end

def create_dsl(path)
  dsl = Object.new
  dsl.define_singleton_method(:url?) { |*_| false }
  dsl.define_singleton_method(:raw_image_data?) { |*_| false }
  dsl.define_singleton_method(:element_width) { |*_| 0 }
  dsl.define_singleton_method(:element_height) { |*_| 0 }

  dsl.class.class_exec do
    attr_accessor :file_path
  end
  dsl.file_path = path

  dsl
end

def bench(dsl, app)
  Benchmark.ips do |benchmark|
    benchmark.report File.basename(dsl.file_path) do
      Shoes::Swt::Image.new(dsl, app)
    end
  end
end

# Benchmarking!!!
check_file(MEDIUM_FILE, "http://zebu.uoregon.edu/hudf/hudf_150dpi.jpg")
check_file(LARGE_FILE, "http://zebu.uoregon.edu/hudf/hudf.jpg")

dsl_small = create_dsl(SMALL_FILE)
dsl_smallish = create_dsl(SMALLISH_FILE)
dsl_medium = create_dsl(MEDIUM_FILE)
dsl_large = create_dsl(LARGE_FILE)

app = Object.new
app.define_singleton_method(:add_paint_listener) { |*_| nil }

bench(dsl_small, app)
bench(dsl_smallish, app)
bench(dsl_medium, app)
bench(dsl_large, app)
