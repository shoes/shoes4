# frozen_string_literal: true

module ParaCreator
  ONION_IPSUM =
    "Pretend that you’ve opened this book (although you probably have opened " \
    "this book), just to find a huge onion right in the middle crease of the " \
    "book. (The manufacturer of the book has included the onion at my " \
    "request.) So you’re like, “Wow, this book comes with an onion!” " \
    "(Even if you don’t particularly like onions, I’m sure you can " \
    "appreciate the logistics of shipping any sort of produce discreetly " \
    "inside of an alleged programming manual.) Then you ask yourself, " \
    "“Wait a minute. I thought this was a book on Ruby, the incredible new " \
    "programming language from Japan. And although I can appreciate the " \
    "logistics of shipping any sort of produce discreetly inside of an " \
    "alleged programming manual: Why an onion? What am I supposed to do with " \
    "it?” No. Please don’t puzzle over it. You don’t need to do anything " \
    "with the onion. Set the onion aside and let it do something with you."

  def create_paras(count)
    count.times { para ONION_IPSUM }
  end
end
