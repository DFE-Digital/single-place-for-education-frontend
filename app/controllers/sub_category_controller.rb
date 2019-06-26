class SubCategoryController < ApplicationController
  def index
    contentful_gateway = Gateway::ContentfulGateway.new(
      space_id: ENV['CONTENTFUL_SPACE_ID'],
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN']
    )

    temp_sub_category = contentful_gateway.get_sub_category(slug: params[:slug])

    return render 'error/404', status: :not_found if temp_sub_category.nil?

    @sub_category = {
      title: temp_sub_category.title,
      slug: temp_sub_category.slug,
      collection_name: temp_sub_category.collection_name,
      breadcrumbs: temp_sub_category.breadcrumbs,
      description: temp_sub_category.description,
      content: temp_sub_category.content
    }

    render 'sub_category/index'
  end
end
