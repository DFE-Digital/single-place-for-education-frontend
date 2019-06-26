class GuidanceController < ApplicationController
  def show
    contentful_gateway = Gateway::ContentfulGateway.new(
      space_id: ENV['CONTENTFUL_SPACE_ID'],
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN']
    )

    temp_guidance = contentful_gateway.get_guidance(slug: params[:slug])

    return render 'error/404', status: :not_found if temp_guidance.nil?

    @guidance = {
      title: temp_guidance.title,
      slug: temp_guidance.slug,
      last_updated: temp_guidance.last_updated,
      content: temp_guidance.content
    }

    render 'guidance/show'
  end
end
