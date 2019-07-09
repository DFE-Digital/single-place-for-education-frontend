require 'rich_text_renderer'

class DefaultRichTextRenderer < RichTextRenderer::BaseNodeRenderer
  def render_content(node)
    content = node['content'].each_with_object([]) do |content_node, result|
      renderer = find_renderer(content_node)
      result << renderer.render(content_node)
    end

    content.join
  end
end
