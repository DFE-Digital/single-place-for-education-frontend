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
  end

  def get_case_study(slug:)
    case_study_response = @client.entries(
      'content_type' => 'caseStudy',
      'include' => 10,
      'fields.slug' => slug
    ).first
    return nil if case_study_response.nil?

    build_case_study_from_response(case_study_response)
  end

private

  def build_case_study_from_response(case_study_response)
    Domain::CaseStudy.new.tap do |case_study|
      case_study.name = case_study_response.name
      case_study.slug = case_study_response.slug
      case_study.hero_image = case_study_response.hero_image.file.url
      case_study.content = build_content_array(case_study_response.content)
    end
  end

  def build_content_array(case_study_response_content)
    content_array = []
    case_study_response_content.each do |content|
      case content.sys[:content_type].id
      when 'image'
        content_array << create_image(content)
      when 'heading'
        content_array << create_heading(content)
      when 'paragraph'
        content_array << create_paragraph(content)
      when  'testimonial' 
        content_array << create_testimonial(content)
      else
        @logger.warn("Content #{content.sys[:content_type].id} not supported")
      end
    end
    content_array
  end

  def create_testimonial(content)
    {
      type: :testimonial,
      data: { 
        heading: create_heading(content.heading)[:data],
        before_quote: { 
          text: content.text.text
        }, 
        quote: {
           text: content.quote.text
        },
         author: {
          text:  content.author.text
        }
      }
    }
  end

  def create_image(content)
    case content.width
    when 'Full Bleed'
      image_type = :full_bleed
    when 'Half Width'
      image_type = :half_width
    when 'Third Width'
      image_type = :thid_width
    when 'Quarter Width'
      image_type = :quarter_width
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
        bold: content.bold
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
end
