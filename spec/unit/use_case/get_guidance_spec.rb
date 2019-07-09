require 'rails_helper'

describe UseCase::GetGuidance do
  let(:slug) { nil }
  let(:contentful_gateway) { spy }
  let(:get_guidance) do
    UseCase::GetGuidance.new(content_gateway: contentful_gateway)
  end
  let(:response) { get_guidance.execute(slug: slug) }

  before { response }

  it 'can call the contentful gateway' do
    expect(contentful_gateway).to have_received(:get_guidance)
  end

  context 'When guidance is Set high expectations (example one)' do
    let(:slug) { 'set-high-expectations' }
    let(:guidance) do

        Domain::Guidance.new.tap do |guidance|
            guidance.title = 'Set high expectations'
            guidance.slug = slug
            guidance.breadcrumbs = [
                {
                  text: 'Home',
                  url: '/'
                },
                {
                  text: 'Hiring and Cat Development',
                  url: '/category/hiring'
                },
                {
                  text: 'Supporting Early Career Cats',
                  url: '/sub-category/early-career-cats'
                },
                {
                  text: 'Set High Expectations',
                  url: '/guidance/set-high-expectations'
                }
              ]
            guidance.last_updated = 'Tue, 25 Jun 2019 00:00:00 +0000'
            guidance.contents_list = [
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
                }
            ]
            guidance.content = [
                {
                    type: :bullet_list, 
                    data: {
                        name: "Set high expectations > What a newly qualified teacher (NQT) needs to learn", 
                        type: :ordered, 
                        large_numbers: true, 
                        items: [
                            {
                                type: :rich_text, 
                                data: {
                                    html_content: "<h3 class=\"govuk-heading-m\" id=\"motivating-pupils\"><b>Motivating pupils</b></h3>\n<p class=\"govuk-body\">Pupils learn well when they feel inspired and motivated. NQTs need to use their teaching ability and skills to improve the wellbeing, motivation and behaviour of their pupils. </p>"
                                }
                            },
                            {
                                type: :rich_text, 
                                data: {
                                    html_content: "<h3 class=\"govuk-heading-m\" id=\"being-a-role-model\"><b>Being a role model</b></h3>\n<p class=\"govuk-body\">Good role models can have a positive and long-lasting impact on pupil learning. NQTs should be great role models to their pupils - influencing their attitudes, values and behaviours. </p>"
                                }
                            }
                        ]
                    }
                }
            ]
        end
    end
    let(:contentful_gateway) { double(get_guidance: guidance) }

    it 'can call the contentful gateway with the slug' do
      expect(contentful_gateway).to have_received(:get_guidance).with(slug: slug)
    end

    it 'can return the title of a guidance' do
      expect(response[:title]).to eq('Set high expectations')
    end

    it 'can return the slug of a guidance' do
      expect(response[:slug]).to eq(slug)
    end

    it 'can return the contents list for the guidance' do
      expect(response[:contents_list]).to eq([
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
        }
      ])
    end

    it 'can return the breadcrumbs of the guidance' do
      expect(response[:breadcrumbs]).to eq([
        {
            text: 'Home',
            url: '/'
        },
        {
            text: 'Hiring and Cat Development',
            url: '/category/hiring'
        },
        {
            text: 'Supporting Early Career Cats',
            url: '/sub-category/early-career-cats'
        },
        {
            text: 'Set High Expectations',
            url: '/guidance/set-high-expectations'
        }
      ])
    end

    it 'can return the content of the guidance' do
      expect(response[:content]).to eq([
        {
            type: :bullet_list, 
            data: {
                name: "Set high expectations > What a newly qualified teacher (NQT) needs to learn", 
                type: :ordered, 
                large_numbers: true, 
                items: [
                    {
                        type: :rich_text, 
                        data: {
                            html_content: "<h3 class=\"govuk-heading-m\" id=\"motivating-pupils\"><b>Motivating pupils</b></h3>\n<p class=\"govuk-body\">Pupils learn well when they feel inspired and motivated. NQTs need to use their teaching ability and skills to improve the wellbeing, motivation and behaviour of their pupils. </p>"
                        }
                    },
                    {
                        type: :rich_text, 
                        data: {
                            html_content: "<h3 class=\"govuk-heading-m\" id=\"being-a-role-model\"><b>Being a role model</b></h3>\n<p class=\"govuk-body\">Good role models can have a positive and long-lasting impact on pupil learning. NQTs should be great role models to their pupils - influencing their attitudes, values and behaviours. </p>"
                        }
                    }
                ]
            }
        }
      ])
    end
  end

  context 'When guidance is Adpative Teaching (example two)' do
    let(:slug) { 'adaptive-teaching' }
    let(:guidance) do

        Domain::Guidance.new.tap do |guidance|
            guidance.title = 'Adaptive Teaching'
            guidance.slug = slug
            guidance.breadcrumbs = [
                {
                  text: 'Home',
                  url: '/'
                },
                {
                  text: 'Hiring and Cat Development',
                  url: '/category/hiring'
                },
                {
                  text: 'Supporting Early Career Cats',
                  url: '/sub-category/early-career-cats'
                },
                {
                  text: 'Adaptive Teaching',
                  url: '/guidance/adaptive-teaching'
                }
              ]
            guidance.last_updated = 'Tue, 21 Jun 2018 00:00:00 +0000'
            guidance.contents_list = [
                {
                    type: :link, 
                    data: {
                        text: "Principles to develop", 
                        type: :internal, 
                        url: "#what-a-newly-qualified-teacher-(nqt)-needs-to-develop"
                    }
                }, 
                {
                    type: :link, 
                    data: {
                        text: "Skills to learn", 
                        type: :internal, 
                        url: "#what-skills-an-nqt-needs-to-learn"
                    }
                }, 
                {
                    type: :link, 
                    data: {
                        text: "Resources", 
                        type: :internal, 
                        url: "#resources"
                    }
                }
            ]
            guidance.content = [
                {
                    type: :bullet_list, 
                    data: {
                        name: "Set high expectations > What a newly qualified teacher (NQT) needs to develop", 
                        type: :ordered, 
                        large_numbers: true, 
                        items: [
                            {
                                type: :rich_text, 
                                data: {
                                    html_content: "<h3 class=\"govuk-heading-m\" id=\"motivating-pupils\"><b>Motivating pupils</b></h3>\n<p class=\"govuk-body\">Pupils learn well when they feel inspired and motivated. NQTs need to use their teaching ability and skills to improve the wellbeing, motivation and behaviour of their pupils. </p>"
                                }
                            },
                            {
                                type: :rich_text, 
                                data: {
                                    html_content: "<h3 class=\"govuk-heading-m\" id=\"being-a-role-model\"><b>Being a role model</b></h3>\n<p class=\"govuk-body\">Good role models can have a positive and long-lasting impact on pupil learning. NQTs should be great role models to their pupils - influencing their attitudes, values and behaviours. </p>"
                                }
                            }
                        ]
                    }
                }
            ]
        end
    end
    let(:contentful_gateway) { double(get_guidance: guidance) }

    it 'can call the contentful gateway with the slug' do
      expect(contentful_gateway).to have_received(:get_guidance).with(slug: slug)
    end

    it 'can return the title of a guidance' do
      expect(response[:title]).to eq('Adaptive Teaching')
    end

    it 'can return the slug of a guidance' do
      expect(response[:slug]).to eq(slug)
    end

    it 'can return the contents list for the guidance' do
      expect(response[:contents_list]).to eq([
        {
            type: :link, 
            data: {
                text: "Principles to develop", 
                type: :internal, 
                url: "#what-a-newly-qualified-teacher-(nqt)-needs-to-develop"
            }
        }, 
        {
            type: :link, 
            data: {
                text: "Skills to learn", 
                type: :internal, 
                url: "#what-skills-an-nqt-needs-to-learn"
            }
        }, 
        {
            type: :link, 
            data: {
                text: "Resources", 
                type: :internal, 
                url: "#resources"
            }
        }
      ])
    end

    it 'can return the breadcrumbs of the guidance' do
      expect(response[:breadcrumbs]).to eq([
        {
            text: 'Home',
            url: '/'
          },
          {
            text: 'Hiring and Cat Development',
            url: '/category/hiring'
          },
          {
            text: 'Supporting Early Career Cats',
            url: '/sub-category/early-career-cats'
          },
          {
            text: 'Adaptive Teaching',
            url: '/guidance/adaptive-teaching'
          }
      ])
    end

    it 'can return the content of the guidance' do
      expect(response[:content]).to eq([
        {
            type: :bullet_list, 
            data: {
                name: "Set high expectations > What a newly qualified teacher (NQT) needs to develop", 
                type: :ordered, 
                large_numbers: true, 
                items: [
                    {
                        type: :rich_text, 
                        data: {
                            html_content: "<h3 class=\"govuk-heading-m\" id=\"motivating-pupils\"><b>Motivating pupils</b></h3>\n<p class=\"govuk-body\">Pupils learn well when they feel inspired and motivated. NQTs need to use their teaching ability and skills to improve the wellbeing, motivation and behaviour of their pupils. </p>"
                        }
                    },
                    {
                        type: :rich_text, 
                        data: {
                            html_content: "<h3 class=\"govuk-heading-m\" id=\"being-a-role-model\"><b>Being a role model</b></h3>\n<p class=\"govuk-body\">Good role models can have a positive and long-lasting impact on pupil learning. NQTs should be great role models to their pupils - influencing their attitudes, values and behaviours. </p>"
                        }
                    }
                ]
            }
        }
      ])
    end
  end

  context 'When no guidance is found' do
    let(:guidance) { nil }
    let(:slug) { 'penguin-teaching' }
    let(:contentful_gateway) { double(get_guidance: guidance) }

    it 'can handle when the gateway returns nil' do
      response = get_guidance.execute(slug: slug)

      expect(response).to eq(nil)
    end
  end
end
