Shoes.app title: 'Samples Executor', width: 540, height: 640 do

  BUTTON_HEIGHT = 20

  samples = File.join(File.dirname(__FILE__), "*.rb")

  stack do
    Dir.glob(samples).sort.each_with_index do |file, index|
      button = button(File.basename(file)) { load file }

      button.style top: (BUTTON_HEIGHT * index), height: BUTTON_HEIGHT
    end
  end

end
