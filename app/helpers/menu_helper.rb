#encoding: utf-8
module MenuHelper
  #renders menu items and emphasizes current menu item
  def topmenu
    pages = {
      "首页" => root_path,
      "最新" => recent_path,
      "热门" => hot_path,
      "新更" => active_path,
      "分类" => class_path
    }
     pages = {
        "pages" => { :name => '首页', :link => root_path},
        "recents" => { :name => '最新', :link => recent_path },
        "hot" => { :name => '推荐', :link => hot_path },
        "actives" => { :name => '新更', :link => active_path },
        "tysqs" => { :name => '天涯', :link => tysq_path },
        "tbs" => { :name => '贴吧', :link => tb_path },
        "dbhts" => { :name => '豆瓣', :link => dbht_path }}
      @current_menu_item = :pages
    pages.map do |key, value|
      classnames = ' class=active' if controller.controller_name == key
      "<li#{classnames}>#{link_to(value[:name], value[:link])}</li>"
    end
  end
end
