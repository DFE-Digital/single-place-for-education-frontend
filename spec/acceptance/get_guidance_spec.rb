require 'rails_helper'

describe 'Get Guidance' do
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
  let(:slug) { 'fulfil-wider-hee-haw-responsibilities' }
  let(:initial_url) do
    "https://cdn.contentful.com/spaces/#{space_id}/environments/master/content_types?limit=1000"
  end
  let(:guidance_url) do
    "https://cdn.contentful.com/spaces/#{space_id}/environments/master/entries?content_type=guidance&include=10&fields.slug=#{slug}"
  end
  let(:contentful_gateway) do
    Gateway::ContentfulGateway.new(
      space_id: space_id,
      access_token: access_token,
      logger: logger
    )
  end
  let(:get_guidance) { UseCase::GetGuidance.new(content_gateway: contentful_gateway) }

  before do
    response_with_no_items = File.open("#{fixtures_path}response_with_no_items.json", &:read)
    response_with_guidance = File.open("#{fixtures_path}guidance/acceptance/response.json", &:read)
    headers['Authorization'] = "Bearer #{access_token}"

    stub_request(:get, initial_url)
      .to_return(status: 200, body: response_with_no_items, headers: {})

    stub_request(:get, guidance_url)
      .to_return(status: 200, body: response_with_guidance, headers: {})

  end

  it 'can retrieve the content of a guidance page' do

    response = get_guidance.execute(slug: slug)
    expected_response = File.open("#{fixtures_path}guidance/acceptance/expected_response.rb", &:read)
    expect(response).to eq(expected_response)

    # expect(response).to eq(
    #   name: 'Case Study - Ssss Primary School',
    #   slug: 'ssss-primary-school-case-study',
    #   hero_image: 'https://some-hero-image-somewhere',
    #   content: [
    #     {
    #       type: :heading,
    #       data: {
    #         text: 'Snek transforms Ssss primary school',
    #         level: :heading_one,
    #         bold: false,
    #         alignment: 'Center'
    #       }
    #     },
    #     {
    #       type: :paragraph,
    #       data: {
    #         text: 'A school business professional secured £300,000 from a local authority to help a primary school build new classrooms and offer more school places.',
    #         alignment: 'center'
    #       }
    #     },
    #     {
    #       type: :small,
    #       data: {
    #         text: 'Published 21 July 2018',
    #         alignment: 'center'
    #       }
    #     },
    #     {
    #       type: :image,
    #       data: {
    #         url: 'https://some-full-bleed-image-somewhere',
    #         width: 'full-bleed'
    #       }
    #     },
    #     {
    #       type: :rich_text,
    #       data: {
    #         html_content: rich_text_expected
    #       }
    #     },
    #     {
    #       type: :testimonial,
    #       data: {
    #         heading: {
    #           text: 'Testimonial',
    #           level: :heading_two,
    #           bold: true,
    #           alignment: 'Left'
    #         },
    #         before_quote: {
    #           text: 'Professssor Snek said to Miss Snek:',
    #           alignment: 'left'
    #         },
    #         quote: {
    #           text: 'Sssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss.',
    #           alignment: 'left'
    #         },
    #         author: {
    #           text: 'Headteacher, Professor Snek',
    #           alignment: 'left'
    #         }
    #       }
    #     }
    #   ]
    # )
  end
end
