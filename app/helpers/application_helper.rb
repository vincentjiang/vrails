module ApplicationHelper

  class CodeRayify < Redcarpet::Render::HTML
    def initialize(extensions = {})
      # 在所有链接中加入target: "_blank"的属性
      super extensions.merge(link_attributes: { target: "_blank" })
    end
    def block_code(code, language)
      language ||= :plaintext
      CodeRay.scan(code, language).div
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
      superscript: true
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
    @page_title = ENV["PROJECT_NAME"]
  end
end
