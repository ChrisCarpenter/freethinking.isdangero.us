atom_feed do |feed|
  feed.title('code.isdangero.us')
  feed.updated((@posts.first.created_at))
  for post in @posts
    feed.entry(post) do |entry|
      entry.title(h(post.title))
      entry.content(RedCloth.new(post.body).to_html, :type => 'html')
      entry.author do |author|
        author.name('Chris Carpenter')
      end
    end
  end
end