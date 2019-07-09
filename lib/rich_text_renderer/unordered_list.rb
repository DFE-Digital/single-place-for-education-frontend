require 'rich_text_renderer/default'

class UnorderedListRichTextRenderer < DefaultRichTextRenderer
  def render(node)
    "<ul class=\"govuk-list govuk-list--bullet\">#{render_content(node)}</ul>"
  end
end
