require 'rails_helper'

describe 'Get Case Study' do
  it 'can retrieve the content of a case study page' do
    case_study_slug = 'case-study-grantham-primary-school'
    contentful_gateway = Gateway::ContentfulGateway.new(
      space_id: '',
      access_token: ''
    )
    get_case_study = UseCase::GetCaseStudy.new(content_gateway: contentful_gateway)

    response = get_case_study.execute(slug: case_study_slug)

    expect(response).to eq({ name: 'Case Study - Grantham Primary School' })
  end
end
