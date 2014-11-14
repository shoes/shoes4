class Shoes
  def self.show_manual(lang = 'English')
    $lang = lang
    load File.join(DIR, 'lib/shoes/ui/help.rb')
  end
end
