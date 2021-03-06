class CategoryController < ApplicationController
  def hiring; end

  def get_a_job
    @response = JSON.parse(HTTParty.get('https://teaching-vacancies.service.gov.uk/api/v1/jobs.json').body)['data']
  end

  def staff_voices; end

  def index
    contentful_gateway = Gateway::ContentfulGateway.new(
      space_id: ENV['CONTENTFUL_SPACE_ID'],
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN']
    )

    temp_category = contentful_gateway.get_category(slug: params[:slug])

    return render 'error/404', status: :not_found if temp_category.nil?

    @category = {
      title: temp_category.title,
      slug: temp_category.slug,
      description: temp_category.description,
      content: temp_category.content
    }

    render 'category/index'
  end
end
