# frozen_string_literal: true

require 'rails_helper'

describe Gateway::ContentfulGateway do
  let(:logger) { spy }
  let(:fixtures_path) { "#{__dir__}/../../fixtures/contentful/case_studies/" }
  let(:headers) do
    {
      'Accept-Encoding' => 'gzip',
      'Connection' => 'close',
      'Content-Type' => 'application/vnd.contentful.delivery.v1+json',
      'Host' => 'cdn.contentful.com',
      'User-Agent' => 'http.rb/3.3.0',
    }
  end
  let(:response_with_no_items) do
    File.open("#{fixtures_path}response_with_no_items.json", &:read)
  end

  context '#get_case_study (example one)' do
    let(:space_id) { 'dog' }
    let(:access_token) { 'woof' }
    let(:slug) { 'baaa-primary-school-case-study' }
    let(:contentful_gateway) do
      described_class.new(space_id: space_id, access_token: access_token, logger: logger)
    end
    let(:initial_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/content_types?limit=1000"
    end
    let(:case_study_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/entries?content_type=caseStudy&include=10&fields.slug=#{slug}"
    end
    let(:case_study) { contentful_gateway.get_case_study(slug: slug) }

    before do
      headers['Authorization'] = "Bearer #{access_token}"

      stub_request(:get, initial_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_no_items, headers: {})

      response_with_items = File.open("#{fixtures_path}case_study_example_one.json", &:read)
      stub_request(:get, case_study_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_items, headers: {})

      case_study
    end

    it 'can send a get request to Contentful' do
      assert_requested :get, case_study_url
    end

    it 'can send a get request to Contentful with a space id' do
      assert_requested :get, initial_url
    end

    it 'can send a get request to Contentful with authorization' do
      assert_requested :get, initial_url, headers: { 'Authorization' => 'Bearer woof' }
    end

    it 'can return a case study with a name' do
      expect(case_study.name).to eq('Case Study - Meow Primary School')
    end

    it 'can return a case study with a slug' do
      expect(case_study.slug).to eq(slug)
    end

    it 'can return a case study with an image' do
      expect(case_study.hero_image).to eq('https://some-image-somewhere')
    end

    it 'can return a case study with content' do
      expect(case_study.content).to eq([
                                         {
                                           type: :image,
                                           data: {
                                             url: 'https://some-image-somewhere',
                                             width: 'full-bleed'
                                           }
                                         },
                                         {
                                           type: :heading,
                                           data: {
                                             text: 'This is a test Woof heading',
                                             level: :heading_one,
                                             bold: true,
                                             alignment: 'Left'
                                           }
                                         },
                                         {
                                           type: :paragraph,
                                           data: {
                                             text: 'This is a Woof paragraph woof woof',
                                             alignment: 'left'
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
                                               text: 'Test wolf testimonial text',
                                               alignment: 'left'
                                             },
                                             quote: {
                                               text: 'Wolves are great',
                                               alignment: 'left'
                                             },
                                             author: {
                                               text: 'Edd the wolf',
                                               alignment: 'left'
                                             }
                                           }
                                         },
                                         {
                                           type: :small,
                                           data: {
                                             text: 'Published 20th June 1999',
                                             alignment: 'left'
                                           }
                                         },
                                         {
                                           type: :link,
                                           data: {
                                             text: 'Linkin Park',
                                             type: :internal,
                                             url: 'linkin-park'
                                           }
                                         },
                                         {
                                           type: :bullet_list,
                                           data: {
                                             name: 'List of Cats',
                                             type: :unordered,
                                             large_numbers: nil,
                                             items: [
                                               {
                                                 type: :paragraph,
                                                 data: {
                                                   text: 'Garfield',
                                                   alignment: 'left'
                                                 }
                                               },
                                               {
                                                 type: :paragraph,
                                                 data: {
                                                   text: 'Meowth',
                                                   alignment: 'left'
                                                 }
                                               }
                                             ]
                                           }
                                         },
                                         {
                                          type: :container,
                                          data: {
                                            background_colour: 'grey',
                                            content: [
                                              {
                                                type: :heading,
                                                data: {
                                                  text: 'I am a Heading of a Container',
                                                  level: :heading_three,
                                                  bold: true,
                                                  alignment: 'Left'
                                                }
                                              }
                                            ]
                                          }
                                         }
                                       ])
    end

    it 'can log when a content type is not supported' do
      expect(logger).to have_received(:warn).with('Content unimplemented not supported')
    end
  end

  context '#get_case_study (example two)' do
    let(:space_id) { 'wolf' }
    let(:access_token) { 'awoo' }
    let(:slug) { 'sss-primary-school-case-study' }
    let(:contentful_gateway) do
      described_class.new(space_id: space_id, access_token: access_token, logger: logger)
    end
    let(:initial_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/content_types?limit=1000"
    end
    let(:case_study_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/entries?content_type=caseStudy&include=10&fields.slug=#{slug}"
    end
    let(:case_study) { contentful_gateway.get_case_study(slug: slug) }

    before do
      headers['Authorization'] = "Bearer #{access_token}"

      stub_request(:get, initial_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_no_items, headers: {})

      response_with_items = File.open("#{fixtures_path}case_study_example_two.json", &:read)
      stub_request(:get, case_study_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_items, headers: {})

      case_study
    end

    it 'can send a get request to Contentful' do
      assert_requested :get, case_study_url
    end

    it 'can send a get request to Contentful with a space id' do
      assert_requested :get, initial_url
    end

    it 'can send a get request to Contentful with authorization' do
      assert_requested :get, initial_url, headers: { 'Authorization' => 'Bearer awoo' }
    end

    it 'can return a case study with a name' do
      expect(case_study.name).to eq('Case Study - Woof Primary School')
    end

    it 'can return a case study with a slug' do
      expect(case_study.slug).to eq(slug)
    end

    it 'can return a case study with an image' do
      expect(case_study.hero_image).to eq('https://a-url-to-an-image')
    end

    it 'can return a case study with content' do
      expect(case_study.content).to eq([
                                         {
                                           type: :image,
                                           data: {
                                             url: 'https://a-url-to-an-image',
                                             width: 'full-bleed'
                                           }
                                         },
                                         {
                                           type: :heading,
                                           data: {
                                             text: 'This is a test Meow heading',
                                             level: :heading_two,
                                             bold: false,
                                             alignment: 'Left'
                                           }
                                         },
                                         {
                                           type: :paragraph,
                                           data: {
                                             text: 'This is a Meow paragraph meow meow',
                                             alignment: 'left'
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
                                               text: 'Test testimonial text',
                                               alignment: 'left'
                                             },
                                             quote: {
                                               text: 'Cats are great',
                                               alignment: 'left'
                                             },
                                             author: {
                                               text: 'Jim the cat',
                                               alignment: 'center'
                                             }
                                           }
                                         },
                                         {
                                           type: :small,
                                           data: {
                                             text: 'Published 23th July 2077',
                                             alignment: 'center'
                                           }
                                         },
                                         {
                                           type: :link,
                                           data: {
                                             text: 'Linkee',
                                             type: :external,
                                             url: 'linkee.com'
                                           }
                                         },
                                         {
                                           type: :bullet_list,
                                           data: {
                                             name: 'List of Dogs',
                                             type: :ordered,
                                             large_numbers: nil,
                                             items: [
                                               {
                                                 type: :paragraph,
                                                 data: {
                                                   text: 'Krypto the Superdog',
                                                   alignment: 'left'
                                                 }
                                               },
                                               {
                                                 type: :paragraph,
                                                 data: {
                                                   text: 'Clifford',
                                                   alignment: 'left'
                                                 }
                                               }
                                             ]
                                           }
                                         },
                                         {
                                          type: :container,
                                          data: {
                                            background_colour: 'cream',
                                            content: [
                                              {
                                                type: :heading,
                                                data: {
                                                  text: 'I am a Heading of Another Container',
                                                  level: :heading_three,
                                                  bold: false,
                                                  alignment: 'Left'
                                                }
                                              }
                                            ]
                                          }
                                         }
                                       ])
    end
  end

  context '#get_case_study (none found example)' do
    let(:space_id) { 'owl' }
    let(:access_token) { 'hoot' }
    let(:slug) { 'hoot-primary-school-case-study' }
    let(:contentful_gateway) do
      described_class.new(space_id: space_id, access_token: access_token)
    end
    let(:initial_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/content_types?limit=1000"
    end
    let(:case_study_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/entries?content_type=caseStudy&include=10&fields.slug=#{slug}"
    end
    let(:case_study) { contentful_gateway.get_case_study(slug: slug) }

    before do
      headers['Authorization'] = "Bearer #{access_token}"

      stub_request(:get, initial_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_no_items, headers: {})

      stub_request(:get, case_study_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_no_items, headers: {})

      case_study
    end

    it 'can return nil when a Contentful case study is not found' do
      expect(case_study).to eq(nil)
    end
  end

  context '#get_case_study with rich text' do
    let(:space_id) { 'owl' }
    let(:access_token) { 'hoot' }
    let(:slug) { 'hoot-primary-school-case-study' }
    let(:contentful_gateway) do
      described_class.new(space_id: space_id, access_token: access_token)
    end
    let(:initial_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/content_types?limit=1000"
    end
    let(:case_study_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/entries?content_type=caseStudy&include=10&fields.slug=#{slug}"
    end
    let(:case_study) { contentful_gateway.get_case_study(slug: slug) }
    let(:response_with_rich_text) do
      File.open("#{fixtures_path}case_study_with_rich_text.json", &:read)
    end
    let(:expected_html_case_study_with_rich_text) do
      File.open("#{fixtures_path}expected_html_case_study_with_rich_text.html", &:read).strip
    end

    before do
      headers['Authorization'] = "Bearer #{access_token}"

      stub_request(:get, initial_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_rich_text, headers: {})

      stub_request(:get, case_study_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_rich_text, headers: {})

      case_study
    end

    it 'can return a case study with rich text' do
      content = case_study.content[0]
      expect(content[:type]).to eq(:rich_text)
      expect(content[:data][:html_content]).to eq(expected_html_case_study_with_rich_text)
    end
  end
end
