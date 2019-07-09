require 'rich_text_renderer/default'

class ParagraphRichTextRenderer < DefaultRichTextRenderer
  def render(node)
    "<p class=\"govuk-body\">#{render_content(node)}</p>"
  end
end
