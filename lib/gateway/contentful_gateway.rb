require 'rich_text_renderer'

class Gateway::ContentfulGateway
  def initialize(space_id:, access_token:, logger: nil)
    @logger = logger
    @logger ||= Logger.new(STDOUT)
    @space_id = space_id
    @access_token = access_token
    @client = Contentful::Client.new(
      access_token: @access_token,
      space: @space_id,
      dynamic_entries: :auto,
      raise_errors: true
    )

    @renderer = RichTextRenderer::Renderer.new(
      'hyperlink' => HyperlinkRenderer,
      'paragraph' => ParagraphRenderer
    )
  end

  def get_case_study(slug:)
    case_study_response = get_content(slug: slug, content_type: 'caseStudy')

    return nil if case_study_response.nil?

    build_case_study_from_response(case_study_response)
  end

  def get_category(slug:)
    category_response = get_content(slug: slug, content_type: 'category')

    return nil if category_response.nil?

    build_category_from_response(category_response)
  end

  def get_sub_category(slug:)
    sub_category_response = get_content(slug: slug, content_type: 'subCategory')

    return nil if sub_category_response.nil?

    build_sub_category_from_response(sub_category_response)
  end

private

  def get_content(slug:, content_type:)
    content_response = @client.entries(
      'content_type' => content_type,
      'include' => 10,
      'fields.slug' => slug
    ).first

    content_response
  end

  def build_case_study_from_response(case_study_response)
    Domain::CaseStudy.new.tap do |case_study|
      case_study.name = case_study_response.name
      case_study.slug = case_study_response.slug
      case_study.hero_image = case_study_response.hero_image.file.url
      case_study.content = build_content_type_array(case_study_response.content)
    end
  end

  def build_category_from_response(category_response)
    Domain::Category.new.tap do |category|
      category.title = category_response.title
      category.slug = category_response.slug
      category.description = build_content_type_array(category_response.description)
      category.content = build_content_type_array(category_response.content)
    end
  end

  def build_sub_category_from_response(sub_category_response)
    Domain::SubCategory.new.tap do |sub_category|
      sub_category.title = sub_category_response.title
      sub_category.slug = sub_category_response.slug
      sub_category.collection_name = sub_category_response.collection_name
      sub_category.description = build_content_type_array(sub_category_response.description)
      sub_category.content = build_content_type_array(sub_category_response.content)
    end
  end

  def build_content_type_array(response_content)
    response_content.map(&method(:parse_content)).compact
  end

  def parse_content(content)
    case content.sys[:content_type].id
    when 'image'
      create_image(content)
    when 'heading'
      create_heading(content)
    when 'paragraph'
      create_paragraph(content)
    when 'small'
      create_small(content)
    when 'testimonial'
      create_testimonial(content)
    when 'multipleColumns'
      create_columns(content)
    when 'link'
      create_link(content)
    when 'bulletList'
      create_bullet_list(content)
    when 'button'
      create_button(content)
    when 'resourceWithIcon'
      create_resource_link_with_icon(content)
    when 'richText'
      create_rich_text(content)
    when 'container'
      create_container(content)
    else
      @logger.warn("Content #{content.sys[:content_type].id} not supported")
      nil
    end
  end

  def create_bullet_list(content)
    items_array = build_content_type_array(content.items)
    {
      type: :bullet_list,
      data: {
        name: content.name,
        type: content.type == 'Unordered' ? :unordered : :ordered,
        items: items_array
      }
    }
  end

  def create_resource_link_with_icon(content)
    {
      type: :resource_link_with_icon,
      data: {
        heading: content.heading,
        text: content.text,
        icon_url: content.icon.url,
        url: content.url
      }
    }
  end

  def create_button(content)
    {
      type: :button,
      data: {
        text: content.button_text,
        type: content.button_type == 'Primary' ? :primary : :secondary,
        url: content.url
      }
    }
  end

  def create_columns(content)
    columns_array = []
    content.columns.each do |column|
      columns_array << build_content_type_array(column.content)
    end
    {
      type: :columns,
      data: {
        heading: content.heading.text,
        columns: columns_array
      }
    }
  end

  def create_small(content)
    {
      type: :small,
      data: {
        text: content.text,
        alignment: content.alignment.downcase
      }
    }
  end

  def create_testimonial(content)
    {
      type: :testimonial,
      data: {
        heading: create_heading(content.heading)[:data],
        before_quote: {
          text: content.before_quote.text
        },
        quote: {
          text: content.quote.text
        },
        author: {
          text: content.author.text,
          alignment: content.author.alignment.downcase
        }
      }
    }
  end

  def create_image(content)
    case content.width
    when 'Full Bleed'
      image_type = 'full-bleed'
    when 'Default'
      image_type = 'default'
    when 'Thumbnail'
      image_type = 'thumbnail'
    when 'Icon'
      image_type = 'icon'
    end

    {
      type: :image,
      data: {
        url: content.file.url,
        width: image_type
      }
    }
  end

  def create_heading(content)
    case content.level
    when 'H1'
      level = :heading_one
    when 'H2'
      level = :heading_two
    when 'H3'
      level = :heading_three
    when 'H4'
      level = :heading_four
    end

    {
      type: :heading,
      data: {
        text: content.text,
        level: level,
        bold: content.bold,
        alignment: content.alignment
      }
    }
  end

  def create_paragraph(content)
    {
      type: :paragraph,
      data: {
        text: content.text
      }
    }
  end

  def create_link(content)
    {
      type: :link,
      data: {
        text: content.text,
        type: content.type == 'Internal' ? :internal : :external,
        url: content.url
      }
    }
  end

  def create_rich_text(content)
    {
      type: :rich_text,
      data: {
        html_content: @renderer.render(content.content)
      }
    }
  end

  def create_container(content)
    {
      type: :container,
      data: {
        background_colour: content.background_colour.downcase,
        content: build_content_type_array(content.content)
      }
    }
  end

  class ParagraphRenderer < RichTextRenderer::BaseNodeRenderer
    def render(node)
      "<p class='govuk-body'>#{render_content(node)}</p>"
    end

    def render_content(node)
      content = node['content'].each_with_object([]) do |content_node, result|
        renderer = find_renderer(content_node)
        result << renderer.render(content_node)
      end

      content.join
    end
  end

  class HyperlinkRenderer < RichTextRenderer::BaseNodeRenderer
    def render(node)
      uri = node['data']['uri']

      "<a class='govuk-link' href=#{uri}>#{render_content(node)}</a>"
    end

    def render_content(node)
      content = node['content'].each_with_object([]) do |content_node, result|
        renderer = find_renderer(content_node)
        result << renderer.render(content_node)
      end

      content.join
    end
  end
end
