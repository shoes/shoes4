# frozen_string_literal: true

require 'thread'
require 'bundler'
require 'English'
require 'open3'
require 'shoes/version'

class ShoesApp < Shoes
  url '/', :home

  url '/start_packaging', :start_packaging
  url '/packaging',       :packaging
  url '/done_packaging',  :done_packaging
  url '/show_error',      :show_error

  def self.packaging_app=(value)
    @packaging_app = value
  end

  def self.packaging_app
    @packaging_app
  end

  def self.notice_error(message)
    Shoes.logger.error message
    ShoesApp.navigation.push "/show_error"
  end

  def self.navigation
    @navigation ||= Queue.new
  end

  def pictures
    image "title.png", left: 150, width: 300, margin_top: 40
    image "orange-shoe.png", width: 120, top: 130
    image "black-shoe.png",  width: 120, top: 130, left: 480
    image "grey-shoe.png",   width: 200, top: 320, left: 80
    image "red-shoe.png",    width: 200, top: 320, left: 300
  end

  def home
    pictures
    stack width: 600, margin_top: 170 do
      tagline link("Open an app") { open_app }, align: "center"
      tagline link("Read the manual") { manual }, align: "center"
      tagline link("Package an app") { visit "/start_packaging" }, align: "center"
      para ""
      para Shoes::VERSION, align: "center"
      para "Press Alt+/ for Console", align: "center"
    end

    every do
      begin
        destination = ShoesApp.navigation.pop(true)
        app.visit destination
      rescue ThreadError
        # Empty queue, no worries...
      end
    end
  end

  def start_packaging
    pictures
    stack width: 600, margin_left: 200, margin_top: 170 do
      @mac = package_check("Mac")
      @windows = package_check("Windows")
      @linux = package_check("Linux")
      @jar = package_check("Java (standalone JAR)")

      @package = button "Package", size: 16, margin_left: 50 do
        if @mac.checked? || @windows.checked? || @linux.checked? || @jar.checked?
          ShoesApp.packaging_app = app.ask_open_file
          if ShoesApp.packaging_app
            args = packaging_args
            # We can't touch actual UI elements from on the other thread!
            # Be careful, and plumb things through ShoesApp.navigation, etc.
            Thread.new do
              begin
                output = ""
                status = 0

                app_dir = File.dirname(ShoesApp.packaging_app)
                package_command = "shoes-swt #{args.join(' ')}"
                if File.exist?(File.join(app_dir, "Gemfile"))
                  output, status = run_command "cd \"#{app_dir}\" && jruby -S bundle install && jruby -S bundle exec #{package_command}"
                else
                  output, status = run_command "cd \"#{app_dir}\" && jruby -S #{package_command}"
                end

                if status.success?
                  ShoesApp.navigation.push "/done_packaging"
                else
                  ShoesApp.notice_error(output)
                end
              rescue e
                ShoesApp.notice_error("#{e}\n#{e.backtrace.join("\t\n")}")
              end
            end

            visit "/packaging"
          end
        else
          app.alert "You must select at least one packaging format."
        end
      end
    end
  end

  def packaging_args
    args = ["package"]
    args << "--mac" if @mac.checked?
    args << "--windows" if @windows.checked?
    args << "--linux" if @linux.checked?
    args << "--jar" if @jar.checked?
    args << ShoesApp.packaging_app
    args
  end

  def packaging
    pictures

    stack width: 600, margin_left: 150, margin_top: 170 do
      subtitle "Packing that up!", align: "center"
      @progress = subtitle "..."
    end

    every 0.2 do
      @progress.text = " " + @progress.text
      @progress.text = "..." if @progress.text.length > 40
    end
  end

  def done_packaging
    pictures
    stack width: 600, margin_left: 150, margin_top: 170 do
      dest = File.join(File.dirname(ShoesApp.packaging_app), "pkg")

      para "Your packages are in:\n  #{dest}\n\n",
           link("Copy location") { app.clipboard = dest },
           "\n",
           link("Start over") { app.visit "/" }
    end
  end

  def show_error
    pictures
    stack width: 600, margin_left: 150, margin_top: 170 do
      subtitle "Whoops!"

      para "Something went wrong\n" \
           "Hit Alt + / to open the Shoes Console and see what it was\n\n",
           link("Start over") { app.visit "/" }
    end
  end

  def run_command(command)
    puts command

    Bundler.with_clean_env do
      out, err, status = Open3.capture3(command)
      output = "STDOUT: #{out}\n\nSTDERR: #{err}"
      [output, status]
    end
  end

  def open_app
    file = app.ask_open_file
    return unless file

    Thread.new do
      app_dir = File.dirname(file)
      if File.exist?(File.join(app_dir, "Gemfile"))
        output, status = run_command "cd \"#{app_dir}\" && jruby -S bundle install && jruby -S bundle exec shoes-swt #{file}"
      else
        output, status = run_command "cd \"#{app_dir}\" && jruby -S shoes-swt #{file}"
      end

      ShoesApp.notice_error(output) unless status.success?
    end
  end

  def manual
    require 'shoes/ui/cli/base_command'
    require 'shoes/ui/cli/manual_command'
    Shoes::UI::CLI::ManualCommand.new.run
  end
end

class PackageCheck < Shoes::Widget
  def initialize_widget(name)
    flow do
      @check = check(checked: true)
      @check.checked = true
      tagline name, click: proc { @check.checked = !@check.checked? }
    end
  end

  def checked?
    @check.checked?
  end
end

Shoes.app width: 600, height: 438, resizable: false
