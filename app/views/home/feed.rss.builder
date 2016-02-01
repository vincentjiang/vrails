#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title author
    xml.author author
    xml.description meta_description
    xml.link "http://vrails.com"
    xml.language "zh-CN"

    for post in @posts
      xml.item do
        if post.title
          xml.title post.title
        else
          xml.title ""
        end
        xml.author author
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link "http://vrails.com/post/#{post.id}"
        xml.content post.content
      end
    end
  end
end
