require 'rich_text_renderer/default'

class HyperlinkRichTextRenderer < DefaultRichTextRenderer
  def render(node)
    uri = node['data']['uri']

    "<a class=\"govuk-link\" href=\"#{uri}\">#{render_content(node)}</a>"
  end
end
