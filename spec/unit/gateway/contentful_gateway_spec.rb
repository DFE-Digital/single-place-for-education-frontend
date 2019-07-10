# frozen_string_literal: true

require 'rails_helper'

describe Gateway::ContentfulGateway do
  let(:logger) { spy }
  let(:fixtures_path) { "#{__dir__}/../../fixtures/contentful/" }
  let(:headers) do
    {
      'Accept-Encoding' => 'gzip',
      'Connection' => 'close',
      'Content-Type' => 'application/vnd.contentful.delivery.v1+json',
      'Host' => 'cdn.contentful.com',
      'User-Agent' => 'http.rb/3.3.0'
    }
  end
  let(:response_with_no_items) do
    File.open("#{fixtures_path}response_with_no_items.json", &:read)
  end

  context '#get_case_study (example one)' do
    let(:space_id) { 'cat' }
    let(:access_token) { 'meow' }
    let(:slug) { 'meow-primary-school-case-study' }
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
    let(:example_fixtures_path) { "#{fixtures_path}case_study/example_one/" }

    before do
      headers['Authorization'] = "Bearer #{access_token}"

      stub_request(:get, initial_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_no_items, headers: {})
    end

    context 'can return a basic case study' do
      before do
        response_with_items = File.open("#{example_fixtures_path}basic.json", &:read)
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
        assert_requested :get, initial_url, headers: { 'Authorization' => "Bearer #{access_token}" }
      end

      it 'can return a case study with a name' do
        expect(case_study.name).to eq('Case Study - Meow Primary School')
      end

      it 'can return a case study with a slug' do
        expect(case_study.slug).to eq(slug)
      end

      it 'can return a case study with a hero image' do
        expect(case_study.hero_image).to eq('https://some-image-somewhere')
      end
    end

    context 'can return a case study with content' do
      it 'including a heading' do
        response_with_headings = File.open("#{example_fixtures_path}with_heading.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_headings, headers: {})

        case_study

        expect(case_study.content).to eq([
          {
            type: :heading,
            data: {
              text: 'Meow Heading 1',
              level: :heading_one,
              bold: false,
              alignment: 'Left'
            }
          }
        ])
      end

      it 'including a paragraph' do
        response_with_paragraph = File.open("#{example_fixtures_path}with_paragraph.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_paragraph, headers: {})

        case_study

        expect(case_study.content).to eq([
          {
            type: :paragraph,
            data: {
              text: 'Meow. Meow. Meow. This is a paragraph.',
              alignment: 'left'
            }
          }
        ])
      end

      it 'including a small' do
        response_with_small = File.open("#{example_fixtures_path}with_small.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_small, headers: {})

        case_study

        expect(case_study.content).to eq([
          {
            type: :small,
            data: {
              text: 'Meow. Meow. Meow. This is a smol.',
              alignment: 'left'
            }
          }
        ])
      end

      it 'including an image' do
        response_with_image = File.open("#{example_fixtures_path}with_image.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_image, headers: {})

        case_study

        expect(case_study.content).to eq([
          {
            type: :image,
            data: {
              url: 'https://some-image-somewhere',
              width: 'full-bleed'
            }
          }
        ])
      end

      it 'including a bullet list' do
        response_with_bullet_list = File.open("#{example_fixtures_path}with_bullet_list.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_bullet_list, headers: {})

        case_study

        expect(case_study.content).to eq([
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
        ])
      end

      it 'including a testimonial' do
        response_with_testimonial = File.open("#{example_fixtures_path}with_testimonial.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_testimonial, headers: {})

        case_study

        expect(case_study.content).to eq([
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
                text: 'Meow. Meow. Meow. This is a before quote.',
                alignment: 'left'
              },
              quote: {
                text: 'Cats are great.',
                alignment: 'left'
              },
              author: {
                text: 'Cate the Cat',
                alignment: 'left'
              }
            }
          }
        ])
      end

      it 'including a container' do
        response_with_container = File.open("#{example_fixtures_path}with_container.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_container, headers: {})

        case_study

        expect(case_study.content).to eq([
          {
            type: :container,
            data: {
              background_colour: 'grey',
              content: [
                {
                  type: :heading,
                  data: {
                    text: 'Cattainer Heading',
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

      it 'including rich text' do
        response_with_rich_text = File.open("#{example_fixtures_path}with_rich_text.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_rich_text, headers: {})

        case_study

        content = case_study.content[0]

        with_rich_text_expected = File.open("#{example_fixtures_path}with_rich_text_expected.html", &:read).strip

        expect(content[:type]).to eq(:rich_text)
        expect(content[:data][:html_content]).to eq(with_rich_text_expected)
      end

      it 'can log when a content type is not supported' do
        response_with_items = File.open("#{example_fixtures_path}with_unimplemented_content_type.json", &:read)
        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_items, headers: {})

        case_study
        expect(logger).to have_received(:warn).with('Content unimplemented not supported')
      end
    end
  end

  context '#get_case_study (example two)' do
    let(:space_id) { 'dog' }
    let(:access_token) { 'woof' }
    let(:slug) { 'woof-primary-school-case-study' }
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
    let(:example_fixtures_path) { "#{fixtures_path}case_study/example_two/" }

    before do
      headers['Authorization'] = "Bearer #{access_token}"

      stub_request(:get, initial_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_no_items, headers: {})
    end

    context 'can return a basic case study' do
      before do
        response_with_items = File.open("#{example_fixtures_path}basic.json", &:read)
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
        assert_requested :get, initial_url, headers: { 'Authorization' => "Bearer #{access_token}" }
      end

      it 'can return a case study with a name' do
        expect(case_study.name).to eq('Case Study - Woof Primary School')
      end

      it 'can return a case study with a slug' do
        expect(case_study.slug).to eq(slug)
      end

      it 'can return a case study with a hero image' do
        expect(case_study.hero_image).to eq('https://some-image-somewhere-else')
      end
    end

    context 'can return a case study with content' do
      it 'including a heading' do
        response_with_headings = File.open("#{example_fixtures_path}with_heading.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_headings, headers: {})

        case_study

        expect(case_study.content).to eq([
          {
            type: :heading,
            data: {
              text: 'Woof Heading 2',
              level: :heading_two,
              bold: true,
              alignment: 'Right'
            }
          }
        ])
      end

      it 'including a paragraph' do
        response_with_paragraph = File.open("#{example_fixtures_path}with_paragraph.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_paragraph, headers: {})

        case_study

        expect(case_study.content).to eq([
          {
            type: :paragraph,
            data: {
              text: 'Woof. Woof. Woof. This is a paragraph.',
              alignment: 'left'
            }
          }
        ])
      end

      it 'including a small' do
        response_with_small = File.open("#{example_fixtures_path}with_small.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_small, headers: {})

        case_study

        expect(case_study.content).to eq([
          {
            type: :small,
            data: {
              text: 'Woof. Woof. Woof. This is a smol.',
              alignment: 'left'
            }
          }
        ])
      end

      it 'including an image' do
        response_with_image = File.open("#{example_fixtures_path}with_image.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_image, headers: {})

        case_study

        expect(case_study.content).to eq([
          {
            type: :image,
            data: {
              url: 'https://some-image-somewhere-else',
              width: 'default'
            }
          }
        ])
      end

      it 'including a bullet list' do
        response_with_bullet_list = File.open("#{example_fixtures_path}with_bullet_list.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_bullet_list, headers: {})

        case_study

        expect(case_study.content).to eq([
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
                    text: 'Krypto',
                    alignment: 'right'
                  }
                },
                {
                  type: :paragraph,
                  data: {
                    text: 'Marley',
                    alignment: 'right'
                  }
                }
              ]
            }
          },
        ])
      end

      it 'including a testimonial' do
        response_with_testimonial = File.open("#{example_fixtures_path}with_testimonial.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_testimonial, headers: {})

        case_study

        expect(case_study.content).to eq([
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
                text: 'Woof. Woof. Woof. This is a before quote.',
                alignment: 'left'
              },
              quote: {
                text: 'Dogs are great.',
                alignment: 'left'
              },
              author: {
                text: 'Doge the Dog',
                alignment: 'left'
              }
            }
          }
        ])
      end

      it 'including a container' do
        response_with_container = File.open("#{example_fixtures_path}with_container.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_container, headers: {})

        case_study

        expect(case_study.content).to eq([
          {
            type: :container,
            data: {
              background_colour: 'cream',
              content: [
                {
                  type: :heading,
                  data: {
                    text: 'Dogtainer Heading',
                    level: :heading_four,
                    bold: false,
                    alignment: 'Left'
                  }
                }
              ]
            }
          }
        ])
      end

      it 'including rich text' do
        response_with_rich_text = File.open("#{example_fixtures_path}with_rich_text.json", &:read)

        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_rich_text, headers: {})

        case_study

        content = case_study.content[0]

        with_rich_text_expected = File.open("#{example_fixtures_path}with_rich_text_expected.html", &:read).strip

        expect(content[:type]).to eq(:rich_text)
        expect(content[:data][:html_content]).to eq(with_rich_text_expected)
      end

      it 'can log when a content type is not supported' do
        response_with_items = File.open("#{example_fixtures_path}with_unimplemented_content_type.json", &:read)
        stub_request(:get, case_study_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_items, headers: {})

        case_study
        expect(logger).to have_received(:warn).with('Content anotherUnimplemented not supported')
      end
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

  context '#get_guidance (example one)' do
    let(:space_id) { 'donkey' }
    let(:access_token) { 'hee-haw' }
    let(:slug) { 'fulfil-wider-hee-haw-responsibilities' }
    let(:contentful_gateway) do
      described_class.new(space_id: space_id, access_token: access_token, logger: logger)
    end
    let(:initial_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/content_types?limit=1000"
    end
    let(:guidance_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/entries?content_type=guidance&include=10&fields.slug=#{slug}"
    end
    let(:guidance) { contentful_gateway.get_guidance(slug: slug) }
    let(:example_fixtures_path) { "#{fixtures_path}guidance/example_one/" }

    before do
      headers['Authorization'] = "Bearer #{access_token}"

      stub_request(:get, initial_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_no_items, headers: {})
    end

    context 'can return a guidance with content' do
      it 'with a contents list' do
        response_with_contents_list = File.open("#{example_fixtures_path}with_contents_list.json", &:read)

        stub_request(:get, guidance_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_contents_list, headers: {})

        guidance

        expect(guidance.contents_list).to eq([
          {
            type: :link,
            data: {
              text: 'Principles to learn',
              type: :internal,
              url: '#what-a-newly-qualified-hee-haw-(nqt)-needs-to-learn'
            }
          },
          {
            type: :link,
            data: {
              text: 'Skills to develop',
              type: :internal,
              url: '#what-skills-an-nqt-needs-to-develop'
            }
          },
          {
            type: :link,
            data: {
              text: 'Case studies',
              type: :internal,
              url: '#case-studies'
            }
          }
        ])
      end
    end
  end

  context '#get_sub_category (example one)' do
    let(:space_id) { 'lion' }
    let(:access_token) { 'roar' }
    let(:slug) { 'supporting-early-career-lions' }
    let(:contentful_gateway) do
      described_class.new(space_id: space_id, access_token: access_token, logger: logger)
    end
    let(:initial_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/content_types?limit=1000"
    end
    let(:sub_category_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/entries?content_type=subCategory&include=10&fields.slug=#{slug}"
    end
    let(:sub_category) { contentful_gateway.get_sub_category(slug: slug) }
    let(:example_fixtures_path) { "#{fixtures_path}sub_category/example_one/" }

    before do
      headers['Authorization'] = "Bearer #{access_token}"

      stub_request(:get, initial_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_no_items, headers: {})
    end

    context 'can return a basic sub-category' do
      before do
        response_with_items = File.open("#{example_fixtures_path}basic.json", &:read)
        stub_request(:get, sub_category_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_items, headers: {})

        sub_category
      end

      it 'can send a get request to Contentful' do
        assert_requested :get, sub_category_url
      end

      it 'can send a get request to Contentful with a space id' do
        assert_requested :get, initial_url
      end

      it 'can send a get request to Contentful with authorization' do
        assert_requested :get, initial_url, headers: { 'Authorization' => "Bearer #{access_token}" }
      end

      it 'can return a sub-category with a title' do
        expect(sub_category.title).to eq('Supporting early career lions')
      end

      it 'can return a sub-category with a slug' do
        expect(sub_category.slug).to eq(slug)
      end

      it 'can return a sub-category with a collection name' do
        expect(sub_category.collection_name).to eq('Guidance')
      end

      it 'can return a sub-category with breadcrumbs' do
        expect(sub_category.breadcrumbs).to eq([
          {
            text: 'Home',
            url: '/'
          },
          {
            text: 'Hiring and lion development',
            url: '/category/hiring'
          }
        ])
      end

      it 'can return a sub-category with a description' do
        expect(sub_category.description).to eq([{
          type: :rich_text,
          data: {
            html_content: "<p class=\"govuk-body\">Starting in September 1997 is the Early Career Framework (ECF). The ECF is a 2-year fully funded programme to help support newly qualified lions.</p>"
          }
        }])
      end
    end

    context 'can return a sub-category with content' do
      it 'including a heading' do
        response_with_headings = File.open("#{example_fixtures_path}with_heading.json", &:read)

        stub_request(:get, sub_category_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_headings, headers: {})

        sub_category

        expect(sub_category.content).to eq([
          {
            type: :heading,
            data: {
              text: 'Lion Standards',
              level: :heading_two,
              bold: false,
              alignment: 'Left'
            }
          }
        ])
      end

      it 'including multiple one half columns' do
        response_with_one_half_columns = File.open("#{example_fixtures_path}with_multiple_one_half_columns.json", &:read)

        stub_request(:get, sub_category_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_one_half_columns, headers: {})

        sub_category

        expect(sub_category.content).to eq([
          {
            type: :columns,
            data: {
              columns: [
                {
                  type: :column,
                  data: {
                    width: 'one-half',
                    content: [
                      {
                        type: :image_link_with_description,
                        data: {
                          image_src: 'https://some-lion-drinking-tea.jpg',
                          link: {
                            type: :link,
                            data: {
                              text: 'Set roar expectations',
                              type: :internal,
                              url: '/guidance/set-roar-expectations'
                            }
                          },
                          description: {
                            type: :rich_text,
                            data: { 
                              html_content: "<p class=\"govuk-body\"><a class=\"govuk-link\" href=\"/guidance/set-roar-expectations\">Set roar expectations</a></p>"
                            }
                          }
                        }
                      }
                    ]
                  }
                },
                {
                  type: :column,
                  data: {
                    width: 'one-half',
                    content: [
                      {
                        type: :image_link_with_description,
                        data: {
                          image_src: 'https://some-lion-teaching-karate.jpg',
                          link: {
                            type: :link,
                            data: {
                              text: 'Promote roar progress',
                              type: :internal,
                              url: '/guidance/promote-roar-progress'
                            }
                          },
                          description: {
                            type: :rich_text,
                            data: {
                              html_content: "<p class=\"govuk-body\"><a class=\"govuk-link\" href=\"/guidance/promote-roar-progress\">Promote roar progress</a></p>"
                            }
                          }
                        }
                      }
                    ]
                  }
                }
              ]
            }
          }
        ])
      end

      it 'including two thirds column' do
        response_with_two_thirds_column = File.open("#{example_fixtures_path}with_two_thirds_column.json", &:read)

        stub_request(:get, sub_category_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_two_thirds_column, headers: {})

        sub_category

        expect(sub_category.content).to eq([
          {
            type: :columns,
            data: {
              columns: [
                {
                  type: :column,
                  data: {
                    width: 'two-thirds',
                    content: [
                      {
                        type: :image_link_with_description,
                        data: {
                          image_src: 'https://some-lion-drinking-tea.jpg',
                          link: {
                            type: :link,
                            data: {
                              text: 'Set roar expectations',
                              type: :internal,
                              url: '/guidance/set-roar-expectations'
                            }
                          },
                          description: {
                            type: :rich_text,
                            data: { 
                              html_content: "<p class=\"govuk-body\"><a class=\"govuk-link\" href=\"/guidance/set-roar-expectations\">Set roar expectations</a></p>"
                            }
                          }
                        }
                      }
                    ]
                  }
                }
              ]
            }
          }
        ])
      end
    end
  end

  context '#get_sub_category (example two)' do
    let(:space_id) { 'cow' }
    let(:access_token) { 'moo' }
    let(:slug) { 'supporting-early-career-cows' }
    let(:contentful_gateway) do
      described_class.new(space_id: space_id, access_token: access_token, logger: logger)
    end
    let(:initial_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/content_types?limit=1000"
    end
    let(:sub_category_url) do
      "https://cdn.contentful.com/spaces/#{space_id}/environments/master/entries?content_type=subCategory&include=10&fields.slug=#{slug}"
    end
    let(:sub_category) { contentful_gateway.get_sub_category(slug: slug) }
    let(:example_fixtures_path) { "#{fixtures_path}sub_category/example_two/" }

    before do
      headers['Authorization'] = "Bearer #{access_token}"

      stub_request(:get, initial_url)
        .with(headers: headers)
        .to_return(status: 200, body: response_with_no_items, headers: {})
    end

    context 'can return a basic sub-category' do
      before do
        response_with_items = File.open("#{example_fixtures_path}basic.json", &:read)
        stub_request(:get, sub_category_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_items, headers: {})

        sub_category
      end

      it 'can send a get request to Contentful' do
        assert_requested :get, sub_category_url
      end

      it 'can send a get request to Contentful with a space id' do
        assert_requested :get, initial_url
      end

      it 'can send a get request to Contentful with authorization' do
        assert_requested :get, initial_url, headers: { 'Authorization' => "Bearer #{access_token}" }
      end

      it 'can return a sub-category with a title' do
        expect(sub_category.title).to eq('Supporting early career cows')
      end

      it 'can return a sub-category with a slug' do
        expect(sub_category.slug).to eq(slug)
      end

      it 'can return a sub-category with a collection name' do
        expect(sub_category.collection_name).to eq('Article')
      end

      it 'can return a sub-category with breadcrumbs' do
        expect(sub_category.breadcrumbs).to eq([
          {
            text: 'Home',
            url: '/'
          },
          {
            text: 'Hiring and cow development',
            url: '/category/hiring'
          }
        ])
      end

      it 'can return a sub-category with a description' do
        expect(sub_category.description).to eq([{
          type: :rich_text,
          data: {
            html_content: "<p class=\"govuk-body\">Starting in September 1993 is the Early Career Framework (ECF). The ECF is a 2-year fully funded programme to help support newly qualified cows.</p>"
          }
        }])
      end
    end

    context 'can return a sub-category with content' do
      it 'including a heading' do
        response_with_headings = File.open("#{example_fixtures_path}with_heading.json", &:read)

        stub_request(:get, sub_category_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_headings, headers: {})

        sub_category

        expect(sub_category.content).to eq([
          {
            type: :heading,
            data: {
              text: 'Cow Standards',
              level: :heading_two,
              bold: false,
              alignment: 'Left'
            }
          }
        ])
      end

      it 'including multiple one half columns' do
        response_with_one_half_columns = File.open("#{example_fixtures_path}with_multiple_one_half_columns.json", &:read)

        stub_request(:get, sub_category_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_one_half_columns, headers: {})

        sub_category

        expect(sub_category.content).to eq([
          {
            type: :columns,
            data: {
              columns: [
                {
                  type: :column,
                  data: {
                    width: 'one-half',
                    content: [
                      {
                        type: :image_link_with_description,
                        data: {
                          image_src: 'https://some-cow-drinking-tea.jpg',
                          link: {
                            type: :link,
                            data: {
                              text: 'Set moo expectations',
                              type: :internal,
                              url: '/guidance/set-moo-expectations'
                            }
                          },
                          description: {
                            type: :rich_text,
                            data: { 
                              html_content: "<p class=\"govuk-body\"><a class=\"govuk-link\" href=\"/guidance/set-moo-expectations\">Set moo expectations</a></p>"
                            }
                          }
                        }
                      }
                    ]
                  }
                },
                {
                  type: :column,
                  data: {
                    width: 'one-half',
                    content: [
                      {
                        type: :image_link_with_description,
                        data: {
                          image_src: 'https://some-cow-teaching-table-tennis.jpg',
                          link: {
                            type: :link,
                            data: {
                              text: 'Promote moo progress',
                              type: :internal,
                              url: '/guidance/promote-moo-progress'
                            }
                          },
                          description: {
                            type: :rich_text,
                            data: {
                              html_content: "<p class=\"govuk-body\"><a class=\"govuk-link\" href=\"/guidance/promote-moo-progress\">Promote moo progress</a></p>"
                            }
                          }
                        }
                      }
                    ]
                  }
                }
              ]
            }
          }
        ])
      end

      it 'including two thirds column' do
        response_with_two_thirds_column = File.open("#{example_fixtures_path}with_two_thirds_column.json", &:read)

        stub_request(:get, sub_category_url)
          .with(headers: headers)
          .to_return(status: 200, body: response_with_two_thirds_column, headers: {})

        sub_category

        expect(sub_category.content).to eq([
          {
            type: :columns,
            data: {
              columns: [
                {
                  type: :column,
                  data: {
                    width: 'two-thirds',
                    content: [
                      {
                        type: :image_link_with_description,
                        data: {
                          image_src: 'https://some-cow-drinking-tea.jpg',
                          link: {
                            type: :link,
                            data: {
                              text: 'Set moo expectations',
                              type: :internal,
                              url: '/guidance/set-moo-expectations'
                            }
                          },
                          description: {
                            type: :rich_text,
                            data: { 
                              html_content: "<p class=\"govuk-body\"><a class=\"govuk-link\" href=\"/guidance/set-moo-expectations\">Set moo expectations</a></p>"
                            }
                          }
                        }
                      }
                    ]
                  }
                }
              ]
            }
          }
        ])
      end
    end
  end
end
