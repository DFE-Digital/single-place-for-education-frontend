class SubCategoryController < ApplicationController
  def index
    contentful_gateway = Gateway::ContentfulGateway.new(
      space_id: ENV['CONTENTFUL_SPACE_ID'],
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN']
    )

    get_sub_category = UseCase::GetSubCategory.new(content_gateway: contentful_gateway)

    @sub_category = get_sub_category.execute(slug: params[:slug])

    return render 'error/404', status: :not_found if @sub_category.nil?

    render 'sub_category/index'
  end
end
