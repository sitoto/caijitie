#encoding: utf-8
#Gretel::Crumbs.layout do
  
  # Remember to restart your application after editing this file.
  crumb :root do
    link "首页", root_path
  end
  
  crumb :blog do
    link "日志列表", blog_path
  end

  crumb :post do |article|
    link article.title, post_path(article)
    parent :blog
  end

  crumb :search do |f|
    link "搜索:" << f, search_path
  end
  crumb :list do |f|
    link  f, ''
  end
  crumb :fun_list do
    link  '短文', funs_path
  end
  crumb :fun_detail do |f|
    link f.title, fun_path(f)
    parent :fun_list
  end
  crumb :download do |f|
    link  f, ''
  end

  crumb :tb do
    link "百度贴吧" ,tb_path
  end
  crumb :tb_list do
    link "热贴列表" ,tb_path
    parent :tb
  end
  crumb :tb_detail do |f|
    link  f.title , p_path(f)
    parent :tb
  end
  
  crumb :tysq do
    link "天涯社区" ,tysq_path
  end
  crumb :tysq_list do
    link "热贴列表" ,tysq_path
    parent :tysq
  end
  crumb :tysq_detail do |f|
    link  f.title , p_path(f)
    parent :tysq
  end

  crumb :dbht do
    link "豆瓣话题" ,dbht_path
  end
  crumb :dbht_list do
    link "热贴列表" ,dbht_path
    parent :dbht
  end
  crumb :dbht_detail do |f|
    link  f.title , p_path(f)
    parent :dbht
  end


  # crumb :project do |project|
  #   link lambda { |project| "#{project.name} (#{project.id.to_s})" }, project_path(project)
  #   parent :projects
  # end
  
  # crumb :project_issues do |project|
  #   link "Issues", project_issues_path(project)
  #   parent :project, project
  # end
  
  # crumb :issue do |issue|
  #   link issue.name, issue_path(issue)
  #   parent :project_issues, issue.project
  # end

#end
