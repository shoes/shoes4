# frozen_string_literal: true
Shoes.app do
  path = File.expand_path(File.join(__FILE__, ".."))
  boing     = sound("#{path}/61847__simon-rue__boink-v3.wav")
  fog_horn  = sound("#{path}/145622__andybrannan__train-fog-horn-long-wyomming.aiff")
  explosion = sound("#{path}/102719__sarge4267__explosion.mp3")
  shields   = sound("#{path}/46492__phreaksaccount__shields1.ogg")

  # Set up three buttons
  button "Boing WAV (740ms)" do
    puts "Boing clicked"
    boing.play
  end

  @two = button "Fog Horn AIFF (2.427s)" do
    puts "Fog Horn clicked"
    fog_horn.play
  end

  button "Explosion MP3 (4.800s)" do
    puts "Explosion clicked"
    explosion.play
  end

  button "Shields UP! OGG (2.473s)" do
    puts "Shields clicked"
    shields.play
  end
end
