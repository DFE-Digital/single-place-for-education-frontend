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

    expect(response).to eq(
      title: "Test Guidance",
      slug: "test-guidance",
      breadcrumbs: [
        {
          text: "Home",
          url: "/"
        },
        {
          text: "Hiring and development",
          url: "/category/hiring"
        },
        {
          text: "Supporting early career teachers",
          url: "/sub-category/supporting-early-career-teachers"
        }
      ],
      last_updated: "Tue, 25 Jun 2019 00:00:00 +0000",
      contents_list: [
        {
          type: :link,
          data: {
            text: "Principles to learn",
            type: :internal,
            url: "#what-a-newly-qualified-teacher-(nqt)-needs-to-learn"
          }
        },
        {
          type: :link,
          data: {
            text: "Skills to develop",
            type: :internal,
            url: "#what-skills-an-nqt-needs-to-develop"
          }
        },
        {
          type: :link,
          data: {
            text: "Resources",
            type: :internal,
            url: "#resources"
          }
        },
        {
          type: :link,
          data: {
            text: "Case studies",
            type: :internal,
            url: "#case-studies"
          }
        }
      ],
      content: [
        {
          type: :image,
          data: {
            url: "//images.ctfassets.net/gfzscr0ovdsz/39APdN7OS30U4GzAG5WfNb/0252dbdf1b6160ec70edc224cdefd581/53224219_1489256524541522_4335915866861461131_n.jpg",
            width: "default"
          }
        },
        {
          type: :rich_text,
          data: {
            html_content: "<h2 class=\"govuk-heading-l\" id=\"what-a-newly-qualified-teacher-(nqt)-needs-to-learn\">What a newly qualified teacher (NQT) needs to learn</h2>\n<p class=\"govuk-body\">There are 7 areas an NQT needs to understand and gain experience in.</p>"
          }
        },
        {
          type: :bullet_list,
          data: {
            name: "Adaptive teaching > What a newly qualified teacher (NQT) needs to learn",
            type: :ordered,
            large_numbers: true,
            items: [
              {
                type: :rich_text,
                data: {
                  html_content: "<h3 class=\"govuk-heading-m\" id=\"understanding-how-pupils-learn-at-different-speeds\"><b>Understanding how pupils learn at different speeds</b></h3>\n<p class=\"govuk-body\">Pupils learn at different rates. Recognising the varying speeds at which pupils learn, and the different types of help they need, will help NQTs create a supportive learning environment.</p>"
                }
              },
              {
                type: :rich_text,
                data: {
                  html_content: "<h3 class=\"govuk-heading-m\" id=\"appreciating-the-differences-between-pupils\"><b>Appreciating the differences between pupils</b></h3>\n<p class=\"govuk-body\">Some pupils will have prior knowledge of subjects, others will have barriers that need to be overcome before they can learn. NQTs should take differences between pupils into account when preparing lessons.</p>"
                }
              },
              {
                type: :rich_text,
                data: {
                  html_content: "<h3 class=\"govuk-heading-m\" id=\"giving-struggling-pupils-special-attention\"><b>Giving struggling pupils special attention</b></h3>\n<p class=\"govuk-body\">Where pupils are struggling, NQTs should be responsive and adapt lessons so they provide targeted support for those who need extra help to succeed.</p>"
                }
              },
              {
                type: :rich_text,
                data: {
                  html_content: "<h3 class=\"govuk-heading-m\" id=\"creating-and-monitoring-learning-groups\"><b>Creating and monitoring learning groups</b></h3>\n<p class=\"govuk-body\">NQTs should organise pupils into flexible groups to give support to those who need it most. Closely monitoring these groups will allow NQTs to spot any impacts on engagement or motivation, and swop groups around if necessary.</p>"
                }
              },
              {
                type: :rich_text,
                data: {
                  html_content: "<h3 class=\"govuk-heading-m\" id=\"treating-groups-of-pupils-the-same\"><b>Treating groups of pupils the same</b></h3>\n<p class=\"govuk-body\">If groups of pupils are given different tasks to complete, it can lower expectations for some students. NQTs should give all pupils the same tasks, and give extra support to any groups of students who are struggling.</p>"
                }
              },
              {
                type: :rich_text,
                data: {
                  html_content: "<h3 class=\"govuk-heading-m\" id=\"planning-lessons-without-worrying-about-learning-styles\"><b>Planning lessons without worrying about learning styles</b></h3>\n<p class=\"govuk-body\">There&#39;s no evidence to suggest that pupils have different learning styles. NQTs should focus on developing lessons that address the needs of pupils, rather than trying to tailor them to different styles of learning.</p>"
                }
              },
              {
                type: :rich_text,
                data: {
                  html_content: "<h3 class=\"govuk-heading-m\" id=\"focusing-on-pupils-with-special-needs\"><b>Focusing on pupils with special needs</b></h3>\n<p class=\"govuk-body\">Pupils with special educational needs or disabilities may require more support. NQTs should work closely with colleagues, families and pupils to understand and tackle any barriers to learning.</p>"
                }
              }
            ]
          }
        }
      ]
    )
  end
end
