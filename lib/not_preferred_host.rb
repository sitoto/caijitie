class NotPreferredHost
  PREFERRED_HOST = "www.lehazi.com"

  def self.matches?(request)
    Rails.env == "production" && request.host != PREFERRED_HOST
  end
end
