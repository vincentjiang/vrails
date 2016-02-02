atom_feed do |feed|
  feed.title author
  feed.updated(@posts[0].created_at) if @posts.length > 0

  @posts.each do |post|
    feed.entry(post) do |entry|
      entry.title(post.title)
      entry.content(post.content, type: 'html')
      entry.author author
    end
  end
end
