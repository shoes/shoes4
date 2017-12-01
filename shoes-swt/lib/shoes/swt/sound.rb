# frozen_string_literal: true

# JavaZOOM Sound-API Projects
#  - Shared lib
require 'shoes/swt/support/tritonus_share.jar'
#  - MP3 lib
require 'shoes/swt/support/mp3spi1.9.5.jar'
require 'shoes/swt/support/jl1.0.1.jar'
#  - Ogg/Vorbis lib
require 'shoes/swt/support/jogg-0.0.7.jar'
require 'shoes/swt/support/jorbis-0.0.15.jar'
require 'shoes/swt/support/vorbisspi1.0.3.jar'

class Shoes
  module Swt
    class Sound
      JFile = java.io.File
      import java.io.BufferedInputStream
      import javax.sound.sampled
      import java.io.IOException

      BUFFER_SIZE = 4096

      def initialize(dsl, _app)
        @dsl = dsl
      end

      def filepath
        @dsl.filepath
      end

      attr_accessor :mixer_channel, :audio_input_stream, :audio_format

      def play
        Thread.new do
          begin
            sound_file = JFile.new(filepath)

            audio_input_stream = AudioSystem.getAudioInputStream(sound_file)
            audio_format = audio_input_stream.getFormat

            decoded_audio_format, decoded_audio_input_stream = decode_input_stream(audio_format, audio_input_stream)

            # Play now.
            rawplay(decoded_audio_format, decoded_audio_input_stream)
            audio_input_stream.close
          rescue UnsupportedAudioFileException => uafex
            puts uafex.inspect, uafex.backtrace
          rescue IOException => ioex
            puts ioex.inspect, ioex.backtrace
          # rescue JIOException => jioex
          #  jioex.stacktrace
          rescue LineUnavailableException => luex
            puts luex.inspect, luex.backtrace
          rescue => e
            puts e.inspect, e.backtrace
          end
        end
      end

      def decode_input_stream(audio_format, audio_input_stream)
        case audio_format.encoding
        when Java::JavazoomSpiVorbisSampledFile::VorbisEncoding, Java::JavazoomSpiMpegSampledFile::MpegEncoding
          decoded_format = AudioFormat.new(AudioFormat::Encoding::PCM_SIGNED,
                                           audio_format.getSampleRate,
                                           16,
                                           audio_format.getChannels,
                                           audio_format.getChannels * 2,
                                           audio_format.getSampleRate,
                                           false)
          decoded_audio_input_stream = AudioSystem.getAudioInputStream(decoded_format, audio_input_stream)

          return decoded_format, decoded_audio_input_stream

        else
          [audio_format, audio_input_stream]
        end
      end

      def rawplay(decoded_audio_format, decoded_audio_input_stream)
        # throws IOException, LineUnavailableException

        sampled_data = Java::byte[BUFFER_SIZE].new

        line = getLine(decoded_audio_format)

        return if line.nil?

        # Start
        line.start
        bytes_read = 0
        while bytes_read != -1
          bytes_read = decoded_audio_input_stream.read(sampled_data, 0, sampled_data.length)
          line.write(sampled_data, 0, bytes_read) if bytes_read != -1
        end

        # Stop
        line.drain
        line.stop
        line.close
        decoded_audio_input_stream.close
      end

      def getLine(audio_format)
        # throws LineUnavailableException
        info = DataLine::Info.new(SourceDataLine.java_class, audio_format)
        res = AudioSystem.getLine(info)
        res.open(audio_format)
        res
      end
    end
  end
end
