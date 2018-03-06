class RedirectsChannel < ApplicationCable::Channel  
  def subscribed
    stream_from "redirects_#{current_user.id}"
  end
end