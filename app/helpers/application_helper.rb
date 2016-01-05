module ApplicationHelper

  class CodeRayify < Redcarpet::Render::HTML
    include ActionView::Helpers::AssetTagHelper
    include ActionView::Helpers::UrlHelper

    def initialize(extensions = {})
      # 在所有链接中加入target: "_blank"的属性
      super extensions.merge(link_attributes: { target: "_blank" })
    end

    # 如果没有标明代码的语言，则使用plaintext来代替
    def block_code(code, language)
      language ||= :plaintext
      CodeRay.scan(code, language).div
    end

    # 改写image方法
    def image(link, title, content)
      filename = link.split("/").last
      link = "#{ENV["QINIU_BUCKET_DOMAIN"]}/#{filename}"
      title = content if title.blank?
      link_to image_tag(link, title: title, alt: content), link, class: "fancybox"
    end

    def table(header, body)
      "<table class=\"table table-striped table-hover table-condensed table-bordered\">" \
        "#{header}#{body}" \
      "</table>"
    end
  end

  def markdown(text)
    renderer = CodeRayify.new(filter_html: true, hard_wrap: true)
    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      strikethrough: true,
      lax_html_blocks: true,
      superscript: true,
      tables: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  def meta_keywords
    @meta_keywords || ENV["META_KEYWORDS"]
  end

  def meta_description
    @meta_description || ENV["META_DESCRIPTION"]
  end

  def page_title
    @page_title.present? ? "#{ENV["PROJECT_NAME"]} | #{@page_title}" : "#{ENV["PROJECT_NAME"]}"
  end
end
