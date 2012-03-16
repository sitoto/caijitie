module GetTiebaPageUrl

  def get_tieba_page_url(url,p)
    regEx_tieba_1 = /baidu\.com\/p\/[0-9]*/
    if regEx_tieba_1  =~ url
        if p.eql?(1)
          myurl = ("http://tieba." << regEx_tieba_1.match(url).to_s)
        else
           myurl = ("http://tieba." << regEx_tieba_1.match(url).to_s) << "?pn=#{p}"
        end
    end
    myurl
  end

  def get_tianya_page_url(url, p)
    regEx_tianya_1 = /tianya\.cn\/\w*\/\w*\/\w*\/[0-9]+\//
    if regEx_tianya_1  =~ url
      myurl = ("http://www." << regEx_tianya_1.match(url).to_s) << "#{p}.shtml"
    end
    myurl
  end
end
