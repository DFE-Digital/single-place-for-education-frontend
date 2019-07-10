class UseCase::GetGuidance
  def initialize(content_gateway:)
    @content_gateway = content_gateway
  end

  def execute(slug:)
    guidance = @content_gateway.get_guidance(slug: slug)
    return nil if guidance.nil?
    {
      title: guidance.title,
      slug: guidance.slug,
      breadcrumbs: guidance.breadcrumbs,
      last_updated: guidance.last_updated,
      contents_list: guidance.contents_list,
      content: guidance.content
    }
  end
end
