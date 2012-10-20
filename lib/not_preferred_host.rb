class NotPreferredHost
  PREFERRED_HOST = "www.369hi.com"

  def self.matches?(request)
    Rails.env == "production" && request.host != PREFERRED_HOST
  end
end
