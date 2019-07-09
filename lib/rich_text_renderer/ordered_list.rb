require 'rich_text_renderer/default'

class OrderedListRichTextRenderer < DefaultRichTextRenderer
  def render(node)
    "<ol class=\"govuk-list govuk-list--number\">#{render_content(node)}</ol>"
  end
end
