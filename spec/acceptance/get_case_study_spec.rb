require 'rails_helper'

describe 'Get Case Study' do
  let(:logger) { spy }
  let(:fixtures_path) { "#{__dir__}/../fixtures/contentful/" }
  let(:headers) do
    {
      'Accept-Encoding' => 'gzip',
      'Connection' => 'close',
      'Content-Type' => 'application/vnd.contentful.delivery.v1+json',
      'Host' => 'cdn.contentful.com',
      'User-Agent' => 'http.rb/3.3.0'
    }
  end
  let(:space_id) { 'snek' }
  let(:access_token) { 'ssss' }
  let(:slug) { 'ssss-primary-school-case-study' }
  let(:initial_url) do
    "https://cdn.contentful.com/spaces/#{space_id}/environments/master/content_types?limit=1000"
  end
  let(:case_study_url) do
    "https://cdn.contentful.com/spaces/#{space_id}/environments/master/entries?content_type=caseStudy&include=10&fields.slug=#{slug}"
  end
  let(:contentful_gateway) do
    Gateway::ContentfulGateway.new(
      space_id: space_id,
      access_token: access_token,
      logger: logger
    )
  end
  let(:get_case_study) { UseCase::GetCaseStudy.new(content_gateway: contentful_gateway) }

  before do
    response_with_no_items = File.open("#{fixtures_path}response_with_no_items.json", &:read)
    response_with_case_study = File.open("#{fixtures_path}case_study/acceptance/response.json", &:read)
    headers['Authorization'] = "Bearer #{access_token}"

    stub_request(:get, initial_url)
      .to_return(status: 200, body: response_with_no_items, headers: {})

    stub_request(:get, case_study_url)
      .to_return(status: 200, body: response_with_case_study, headers: {})
  end

  it 'can retrieve the content of a case study page' do
    response = get_case_study.execute(slug: slug)

    rich_text_expected = File.open("#{fixtures_path}case_study/acceptance/rich_text_expected.html", &:read).strip

    expect(response).to eq(
      name: 'Case Study - Ssss Primary School',
      slug: 'ssss-primary-school-case-study',
      hero_image: 'https://some-hero-image-somewhere',
      content: [
        {
          type: :heading,
          data: {
            text: 'Snek transforms Ssss primary school',
            level: :heading_one,
            bold: false,
            alignment: 'Center'
          }
        },
        {
          type: :paragraph,
          data: {
            text: 'A school business professional secured £300,000 from a local authority to help a primary school build new classrooms and offer more school places.',
            alignment: 'center'
          }
        },
        {
          type: :small,
          data: {
            text: 'Published 21 July 2018',
            alignment: 'center'
          }
        },
        {
          type: :image,
          data: {
            url: 'https://some-full-bleed-image-somewhere',
            width: 'full-bleed'
          }
        },
        {
          type: :rich_text,
          data: {
            html_content: rich_text_expected
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
              text: 'Professssor Snek said to Miss Snek:',
              alignment: 'left'
            },
            quote: {
              text: 'Sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss.',
              alignment: 'left'
            },
            author: {
              text: 'Headteacher, Professor Snek',
              alignment: 'left'
            }
          }
        }
      ]
    )
  end
end
