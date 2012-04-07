#encoding: utf-8
module MenuHelper
  #renders menu items and emphasizes current menu item
  def topmenu
    pages = {
      "首页" => root_path,
      "最新" => recent_path,
      "热门" => hot_path,
      "分类" => class_path
    }
     pages = {
        "pages" => { :name => '首页', :link => root_path},
        "recent" => { :name => '最新', :link => recent_path },
        "hot" => { :name => '热门', :link => hot_path },
        "class" => { :name => '分类', :link => class_path }}
      @current_menu_item = :pages
    pages.map do |key, value|
      classnames = ' class=current-menu-item' if controller.controller_name == key
      "<li#{classnames}>#{link_to(value[:name], value[:link])}</li>"
    end
  end
end