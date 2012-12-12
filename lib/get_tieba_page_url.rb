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
  def get_doubanhuati_page_url(url,p)
    if p == 0
     url
    else
     "#{url}?start=#{p.to_s}"
    end
  end

  def get_tianya_page_url(url, p)
    regEx_tianya_1 = /tianya\.cn\/\w*\/\w*\/\w*\/[0-9]+\//
    if regEx_tianya_1  =~ url
      myurl = ("http://www." << regEx_tianya_1.match(url).to_s) << "#{p}.shtml"
    end
    myurl
  end

  def get_tianya_techfroum_page_url(url, p)
  regEx_tianya_1 = /tianya\.cn\/\w*\/\w*\/\w*\//
  regEx_filename = /\/[0-9]+\.shtml/
  filename = regEx_filename.match(url).to_s

    if regEx_tianya_1  =~ url
      myurl = ("http://www." << regEx_tianya_1.match(url).to_s) << "#{p}" << filename
    end
    myurl
  end
  #http://bbs.tianya.cn/post-16-825252-2.shtml
  
  def get_tianya_bbs_page_url(url, p)
  regEx_tianya_1 = /bbs\.tianya\.cn\/\w*\-\w*\-\w*\-/
  
  filename = ".shtml"

    if regEx_tianya_1  =~ url
      myurl = ("http://" << regEx_tianya_1.match(url).to_s) << "#{p}" << filename
    end
    myurl
  end
end
