# frozen_string_literal: true

require 'yaml'

Shoes.app title: "A Gentle Reminder",
          width: 370, height: 560, resizable: false do
  background white
  background tan, height: 40

  caption "A Gentle Reminder", margin: 8, stroke: white

  stack margin: 10, margin_top: 50 do
    para "You need to", stroke: red, fill: yellow

    stack margin_left: 5, margin_right: 10, width: 1.0, height: 200, scroll: true do
      background white
      border white, strokewidth: 3
      @gui_todo = para
    end

    flow margin_top: 10 do
      para "Remember to"
      @add = edit_line(margin_left: 10, width: 180)
      button("Add", margin_left: 5) do
        add_todo(@add.text)
        @add.text = ''
      end
    end
  end

  stack margin_top: 10 do
    background darkgray
    para strong('Completed'), stroke: white
  end

  @gui_completed = stack width: 1.0, height: 207, margin_right: 20

  def data_path
    user_data_directory = if RUBY_PLATFORM =~ /win32/
                            if ENV['USERPROFILE']
                              if File.join(File.expand_path(ENV['USERPROFILE']), "Application Data")
                                File.join File.expand_path(ENV['USERPROFILE']), "Application Data", "GentleReminder"
                              else
                                File.join File.expand_path(ENV['USERPROFILE']), "GentleReminder"
                              end
                            else
                              File.join File.expand_path(Dir.getwd), "data"
                            end
                          else
                            File.expand_path(File.join("~", ".gentlereminder"))
                          end

    Dir.mkdir(user_data_directory) unless File.exist?(user_data_directory)

    File.join(user_data_directory, "data.yaml")
  end

  def refresh_todo
    @gui_todo.replace(
      *@todo.map do |item|
        [item, '  '] + [link('Done') { complete_todo item }] + ['  '] +
          [link('Forget it') { forget_todo item }] + ["\n"]
      end.flatten
    )
  end

  def refresh
    refresh_todo

    @gui_completed.clear

    @gui_completed.append do
      background white

      @completed.keys.sort.reverse_each do |day|
        stack do
          background lightgray
          para strong(day.strftime('%B %d, %Y')), stroke: white
        end

        stack do
          inscription(
            * @completed[day].map do |item|
              [item] + ['  '] + [link('Not Done') { undo_todo day, item }] +
                  (@completed[day].index(item) == @completed[day].length - 1 ? [''] : ["\n"])
            end.flatten
          )
        end
      end
    end
  end

  def complete_todo(item)
    day = Date.today

    if @completed.keys.include? day
      @completed[day] << item
    else
      @completed[day] = [item]
    end

    @todo.delete(item)

    save

    refresh
  end

  def undo_todo(day, item)
    @completed[day].delete item

    @completed.delete(day) if @completed[day].empty?

    @todo << item unless @todo.include? item

    save

    refresh
  end

  def add_todo(item)
    item = item.strip

    return if item == ''

    if @todo.include? item
      alert('You have already added that to the list!')
      return
    end

    @todo << item

    save

    refresh_todo
  end

  def forget_todo(item)
    @todo.delete item

    save

    refresh_todo
  end

  def load
    if File.exist?(data_path)
      @todo, @completed = YAML.safe_load(File.open(data_path, 'r'), [Date])
    else
      @todo = []
      @completed = {}
    end

    refresh
  end

  def save
    File.open(data_path, 'w') do |f|
      f.write [@todo, @completed].to_yaml
    end
  end

  load
end
