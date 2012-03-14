# encoding: utf-8
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { page_title.to_s }
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def google_analytics account = GOOGLE_ANALYTICS_KEY, always = false
    # This helper should be called at end of the <head> tag
    "<script>var _gaq=_gaq || [];_gaq.push(['_setAccount','#{account}']);_gaq.push(['_trackPageview']);(function(){var ga=document.createElement('script');ga.async=true;ga.src=('https:'==document.location.protocol?'https://ssl':'http://www')+'.google-analytics.com/ga.js';(document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ga);})();</script>".html_safe if (always || Rails.env.to_sym == :production)
  end

  def baidu_analytics always = false
    "<script type='text/javascript'>
var _bdhmProtocol = (('https:' == document.location.protocol) ? ' https://' : ' http://');
document.write(unescape('%3Cscript src='' + _bdhmProtocol + 'hm.baidu.com/h.js%3F0f284046f8572093596ffc02be08fc65' type='text/javascript'%3E%3C/script%3E'));
</script>".html_safe if (always || Rails.env.to_sym == :production)
  end

  def like_button(url = WEIBO_QQ_URL)
    "<a href='#{url}' title='t.qq.com'>腾讯微博</a>".html_safe
  end
end
