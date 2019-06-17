class UseCase::GetCaseStudy
  def initialize(content_gateway:)
    @content_gateway = content_gateway
  end

  def execute(slug:)
    case_study = @content_gateway.get_case_study(slug: slug)
    return nil if case_study.nil?

    {
      name: case_study.name,
      slug: case_study.slug,
      hero_image: case_study.hero_image,
      content: case_study.content
    }
  end
end
