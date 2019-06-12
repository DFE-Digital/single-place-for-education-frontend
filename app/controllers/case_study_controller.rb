class CaseStudyController < ApplicationController
  def show
    contentful_gateway = Gateway::ContentfulGateway.new(
      space_id: ENV['CONTENTFUL_SPACE_ID'],
      access_token: ENV['CONTENTFUL_ACCESS_TOKEN']
    )

    get_case_study = UseCase::GetCaseStudy.new(content_gateway: contentful_gateway)
    @case_study = get_case_study.execute(slug: params[:slug])

    if @case_study[:slug] == "#{params[:slug]}"
      render 'case_study/show'
    else
      render :file => "#{Rails.root}/public/404.html", layout: false, status: :not_found
    end
  end
end
