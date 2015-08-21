#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title ENV["PROJECT_NAME"]
    xml.author ENV["USERNAME"]
    xml.description ENV["META_DESCRIPTION"]
    xml.link "http://vrails.com"
    xml.language "zh-CN"

    for post in @posts
      xml.item do
        if post.title
          xml.title post.title
        else
          xml.title ""
        end
        xml.author ENV["USERNAME"]
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link "http://vrails.com/post/#{post.id}"
        xml.content post.content
      end
    end
  end
end
