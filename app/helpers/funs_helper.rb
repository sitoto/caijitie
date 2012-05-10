#encoding: utf-8
module FunsHelper
  def fun_excerpt(fun)
    fun.html_content.html_safe.split('</p>').first+'</p>'.html_safe
    #RedCloth.new(fun.html_content.html_safe).to_html
  end

  def fun_tags_html fun
    tags = fun.tags.order 'name'
    return '' if !tags || tags.length == 0

    links = []
    tags.each do |tag|
      links << link_to(tag.name, tag, :class => 'tag', :target => '_blank')
    end
    (' in '+links.to_sentence).html_safe
  end

  def fun_tags_keyword fun
    tags = fun.title

  end

  def fun_description(fun)
    fun.body.truncate(128)
  end

  def fun_published_time_in_words fun
    words = time_ago_in_words(fun.updated_at)
    if fun.published?
      "#{words} ago"
    else
      "in #{words}"
    end
  end
end
       