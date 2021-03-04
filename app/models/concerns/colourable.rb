module Colourable
  extend ActiveSupport::Concern

  def background_color
    sprintf("#%06x", (email.sum % (256*256*256)))
  end

  def text_color
    Chroma.paint(background_color).dark? ? "#fff" : "#000"
  end
end
