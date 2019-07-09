class GuidanceController < ApplicationController
  def show
    contentful_gateway = Gateway::ContentfulGateway.new(
      space_id: ENV['CONTENTFUL_SPACE_ID'],
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN']
    )

    get_guidance = UseCase::GetGuidance.new(content_gateway: contentful_gateway)

    @guidance = get_guidance.execute(slug: params[:slug])

    if !@guidance.nil? && @guidance[:slug] == params[:slug].to_s
      render 'guidance/show'
    else
      render 'error/404', status: :not_found
    end
  end
end
