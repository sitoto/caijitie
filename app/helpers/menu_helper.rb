#encoding: utf-8
module MenuHelper
  #renders menu items and emphasizes current menu item
  def topmenu
     pages = {
        "pages" => { :name => '<cite>首页</cite>', :link => root_path, :index => 1},
        "active" => { :name => '<cite>最近更新</cite>', :link => active_path, :index => 2 },
        "hot" => { :name => '<cite>热门文章</cite>', :link => hot_path, :index => 3 },
        "recent" => { :name => '<cite>文章列表</cite>', :link => recent_path, :index => 4 }
     }
    pages.map do |key, value|
      classnames = " class='on#{value[:index]}'" if controller.controller_name == key
      "<li#{classnames}>#{link_to(value[:name], value[:link], class: "m#{value[:index]}")}</li>"
      "<li#{classnames}><a href='#{value[:link]}' class='m#{value[:index]}'  ></a> #{value[:name]}</li>"
    end
  end
end