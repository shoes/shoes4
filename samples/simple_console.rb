# frozen_string_literal: true

Shoes.app do
  para "Hit Alt + / to open the shoes console and see different message!"

  flow do
    %w[info debug warn error].each do |type|
      button type.to_s do
        public_send type, "This is a #{type} message"
      end
    end
  end
end
