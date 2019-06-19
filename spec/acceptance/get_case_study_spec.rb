require 'rails_helper'

describe 'Get Case Study' do
  let(:logger) { spy }
  let(:fixtures_path) { "#{__dir__}/../fixtures/contentful/case_studies/" }
  let(:headers) do
    {
      'Accept-Encoding' => 'gzip',
      'Connection' => 'close',
      'Content-Type' => 'application/vnd.contentful.delivery.v1+json',
      'Host' => 'cdn.contentful.com',
      'User-Agent' => 'http.rb/3.3.0',
    }
  end

  let(:space_id) { 'cat' }
  let(:access_token) { 'meow' }
  let(:slug) { 'case-study-grantham-primary-school' }
  let(:initial_url) do
    "https://cdn.contentful.com/spaces/#{space_id}/environments/master/content_types?limit=1000"
  end
  let(:case_study_url) do
    "https://cdn.contentful.com/spaces/#{space_id}/environments/master/entries?content_type=caseStudy&include=10&fields.slug=#{slug}"
  end

  context '#when the case study has content' do
    before do
      response_with_no_items = File.open("#{fixtures_path}response_with_no_items.json", &:read)
      response_with_items = File.open("#{fixtures_path}case_study_acceptance.json", &:read)
      headers['Authorization'] = "Bearer #{access_token}"

      stub_request(:get, initial_url)
        .to_return(status: 200, body: response_with_no_items, headers: {})

      stub_request(:get, case_study_url)
        .to_return(status: 200, body: response_with_items, headers: {})
    end

    it 'can retrieve the content of a case study page' do
      contentful_gateway = Gateway::ContentfulGateway.new(
        space_id: space_id,
        access_token: access_token,
        logger: logger
      )
      get_case_study = UseCase::GetCaseStudy.new(content_gateway: contentful_gateway)

      response = get_case_study.execute(slug: slug)

      expect(response).to eq(
        name: 'Case Study - Grantham Primary School',
        slug: 'case-study-grantham-primary-school',
        hero_image: '//images.ctfassets.net/grantham-hero-image.png',
        content: [
          {
            type: :image,
            data: {
              url: '//images.ctfassets.net/grantham-hero-image.png',
              width: 'full-bleed'
            }
          },
          {
            type: :heading,
            data: {
              text: 'School leader transforms Grantham primary school',
              level: :heading_one,
              bold: true,
              alignment: 'Left'
            }
          },
          {
            type: :paragraph,
            data: {
              text: 'This is a paragraph'
            }
          },
          {
            type: :testimonial,
            data: {
              heading: {
                text: 'Testimonial',
                level: :heading_two,
                bold: true,
                alignment: 'Left'
              },
              before_quote: {
                text: 'Test testimonial text'
              },
              quote: {
                text: 'Cats are great'
              },
              author: {
                text:  'Jim the cat',
                alignment: 'left'
              }
            }
          },
          {
            type: :small,
            data: {
              text: 'Published 4th June 2019',
              alignment: 'left'
            }
          }
        ]
      )
    end
  end
end
