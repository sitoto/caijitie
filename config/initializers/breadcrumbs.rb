#encoding: utf-8
Gretel::Crumbs.layout do
  
  # Remember to restart your application after editing this file.
  crumb :root do
    link "首页", root_path
  end
  
  crumb :blog do
    link "文章", blog_path
  end

  crumb :post do |article|
    link article.title, post_path(article)
    parent :blog
  end

  crumb :search do |f|
    link "搜索:" << f, search_path
  end

  crumb :tb do
    link "百度贴吧" ,tb_path
  end
  crumb :tb_list do
    link "热贴列表" ,tb_path
    parent :tb
  end
  crumb :tb_list_detail do |f|
    link  f.title , p_path(f)
    parent :tb_list
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

end