module PuHelper
  def change_image_url str
    reg_img = Regexp.new("<img.[^>]*src(=| )(.[^>]*)>")

    mc = reg_img.match(str)
    str.gsub(reg_img, '<img')
    mc.each do |f|

    end
  end

  def show_page_list

  end
end
