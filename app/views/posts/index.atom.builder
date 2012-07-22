atom_feed do |feed|
  feed.title("369hi.com")
  feed.updated(@posts.first.published_at)

  @posts.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content(post.html_content.html_safe, :type => "html")
      entry.author { |author| author.name("369hi") }
    end
  end
end
