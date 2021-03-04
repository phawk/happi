module ImageHelper
  def avatar_url(user, size: 32)
    if user.try(:avatar)
      user.avatar.variant(resize_to_fill: [size, size])
    else
      name = [user.first_name, user.last_name].join("%20")
      background = user.try(:background_color).presence || "FFE299"
      text = user.try(:text_color).presence || "000"
      "https://eu.ui-avatars.com/api/?name=#{name}&size=#{size*2}&background=#{background.delete_prefix("#")}&color=#{text.delete_prefix("#")}"
    end
  end

  def avatar_tag(user, size: 32, extra_class: "")
    image_tag avatar_url(user, size: size), alt: user.email, width: size, height: size, class: "rounded-full object-cover #{extra_class}"
  end
end
