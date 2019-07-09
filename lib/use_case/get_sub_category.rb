class UseCase::GetSubCategory
  def initialize(content_gateway: contentful_gateway)
    @content_gateway = content_gateway
  end

  def execute(slug:)
    sub_category = @content_gateway.get_sub_category(slug: slug)

    return nil if sub_category.nil?

    {
      title: sub_category.title,
      slug: sub_category.slug,
      collection_name: sub_category.collection_name,
      breadcrumbs: sub_category.breadcrumbs,
      description: sub_category.description,
      content: sub_category.content
    }
  end
end
