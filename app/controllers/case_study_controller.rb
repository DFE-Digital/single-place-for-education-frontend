class CaseStudyController < ApplicationController
  def show
    contentful_gateway = Gateway::ContentfulGateway.new(
      space_id: ENV['CONTENTFUL_SPACE_ID'],
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN']
    )

    get_case_study = UseCase::GetCaseStudy.new(content_gateway: contentful_gateway)
    @case_study = get_case_study.execute(slug: params[:slug])

    if !@case_study.nil? && @case_study[:slug] == params[:slug].to_s
      render 'case_study/show'
    else
      render 'error/404', status: :not_found
    end
  end
end
