class NotPreferredHost
  PREFERRED_HOST = "www.tuoshuiba.com"

  def self.matches?(request)
    Rails.env == "production" && request.host != PREFERRED_HOST
  end
end
