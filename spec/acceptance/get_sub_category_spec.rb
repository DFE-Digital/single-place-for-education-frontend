require 'rails_helper'

describe 'Get Sub-Category' do
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
  let(:space_id) { 'frog' }
  let(:access_token) { 'ribbit' }
  let(:slug) { 'supporting-early-career-frogs' }
  let(:initial_url) do
    "https://cdn.contentful.com/spaces/#{space_id}/environments/master/content_types?limit=1000"
  end
  let(:sub_category_url) do
    "https://cdn.contentful.com/spaces/#{space_id}/environments/master/entries?content_type=subCategory&include=10&fields.slug=#{slug}"
  end
  let(:contentful_gateway) do
    Gateway::ContentfulGateway.new(
      space_id: space_id,
      access_token: access_token,
      logger: logger
    )
  end
  let(:get_sub_category) { UseCase::GetSubCategory.new(content_gateway: contentful_gateway) }

  before do
    response_with_no_items = File.open("#{fixtures_path}response_with_no_items.json", &:read)
    response_with_case_study = File.open("#{fixtures_path}sub_category/acceptance/response.json", &:read)
    headers['Authorization'] = "Bearer #{access_token}"

    stub_request(:get, initial_url)
      .to_return(status: 200, body: response_with_no_items, headers: {})

    stub_request(:get, sub_category_url)
      .to_return(status: 200, body: response_with_case_study, headers: {})
  end

  it 'can retrieve the content of a sub category page' do
    response = get_sub_category.execute(slug: slug)

    expect(response).to eq(
      title: 'Supporting early career frogs',
      slug: 'supporting-early-career-frogs',
      collection_name: 'Guidance',
      breadcrumbs: [
        {
          text: 'Home',
          url: '/'
        },
        {
          text: 'Hiring and development',
          url: '/category/hiring'
        }
      ],
      description: [{
        type: :rich_text,
        data: {
          html_content: "<p class=\"govuk-body\">Starting in September 1973 is the Early Career Framework (ECF). The ECF is a 2-year fully funded programme to help support newly qualified frogs.</p>"
        }
      }],
      content: [
        {
          type: :heading,
          data: {
            text: 'Frog Standards',
            level: :heading_two,
            bold: false,
            alignment: 'Left'
          }
        },
        {
          type: :columns,
          data: {
            columns: [
              [
                {
                  type: :image_link_with_description,
                  data: {
                    image_src: 'https://some-frog-drinking-tea.jpg',
                    link: {
                      type: :link,
                      data: {
                        text: 'Set ribbit expectations',
                        type: :internal,
                        url: '/guidance/set-ribbit-expectations'
                      }
                    },
                    description: {
                      type: :rich_text,
                      data: {
                        html_content: "<p class=\"govuk-body\"><a class=\"govuk-link\" href=\"/guidance/set-ribbit-expectations\">Set ribbit expectations</a></p>"
                      }
                    }
                  }
                }
              ],
              [
                {
                  type: :image_link_with_description,
                  data: {
                    image_src: 'https://some-frog-holding-pen.jpg',
                    link: {
                      type: :link,
                      data: {
                        text: 'Promote ribbit progress',
                        type: :internal,
                        url: '/guidance/promote-ribbit-progress'
                      }
                    },
                    description: {
                      type: :rich_text,
                      data: {
                        html_content: "<p class=\"govuk-body\"><a class=\"govuk-link\" href=\"/guidance/promote-ribbit-progress\">Promote ribbit progress</a></p>"
                      }
                    }
                  }
                }
              ]
            ]
          }
        }
      ]
    )
  end
end
