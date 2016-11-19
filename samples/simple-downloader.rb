Shoes.app do
  background "#eee"
  @list = stack do
    para "Enter a URL to download:", margin: [10, 8, 10, 0]
    flow margin: 10 do
      @url = edit_line width: -120
      button "Download", width: 120 do
        @list.append do
          stack do
            background "#eee".."#ccd"
            stack margin: 10 do
              dl = nil
              para @url.text, " [", link("cancel") { dl.abort }, "]", margin: 0
              status = inscription "Beginning transfer.", margin: 0
              p = progress width: 1.0, height: 14
              dl = download @url.text, save: File.basename(@url.text),
                                       progress: proc { |d|
                                         status.text = "Transferred #{d.transferred} of #{d.length} bytes (#{d.percent}%)"
                                         p.fraction = d.percent * 0.01
                                       },
                                       finish: proc { status.text = "Download completed" }
            end
          end
        end
      end
    end
  end
end
