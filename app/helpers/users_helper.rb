module UsersHelper

  def gravatar_for(user, size=80, badge=false)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?size=#{size}&d=monsterid"
    if badge
      img_class = 'gravatar gravatar-badge'
    else
      img_class = 'gravatar'
    end
    image_tag(gravatar_url, alt: user.name, class: img_class)
  end
end
