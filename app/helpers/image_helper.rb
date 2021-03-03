module ImageHelper
  def avatar_url(user, size: 32)
    name = [user.first_name, user.last_name].join("%20")
    "https://eu.ui-avatars.com/api/?name=#{name}&size=#{size*2}&background=FFE299&color=000"
  end

  def avatar_tag(user, size: 32, extra_class: "")
    image_tag avatar_url(user, size: size), alt: user.email, width: size, height: size, class: "rounded-full object-cover #{extra_class}"
  end
end
