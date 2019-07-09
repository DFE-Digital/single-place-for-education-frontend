require 'rich_text_renderer/default'

class HeadingRichTextRenderer < DefaultRichTextRenderer
  def render(node)
    heading_level, css_class =
      case node['nodeType']
      when 'heading-1'
        ['h1', 'govuk-heading-xl']
      when 'heading-2'
        ['h2', 'govuk-heading-l']
      when 'heading-3'
        ['h3', 'govuk-heading-m']
      when 'heading-4'
        ['h4', 'govuk-heading-s']
      end

    id = node['content'][0]['value'].gsub(' ', '-').downcase

    "<#{heading_level} class=\"#{css_class}\" id=\"#{id}\">#{render_content(node)}</#{heading_level}>"
  end
end
