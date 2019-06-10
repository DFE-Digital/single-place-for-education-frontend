class ContentfulGatewayStub
  attr_reader :is_get_case_study_called, :get_case_study_called_with

  def initialize
    @is_get_case_study_called = false
  end

  def get_case_study(slug:)
    @is_get_case_study_called = true
    @get_case_study_called_with = slug
    Domain::CaseStudy.new.tap do |case_study|
      if slug == 'case-study-grantham-primary-school'
        case_study.name = 'Case Study - Grantham Primary School'
        case_study.slug = 'case-study-grantham-primary-school'
        case_study.hero_image = '//images.ctfassets.net/grantham-hero-image.png'
        case_study.content = [{
          type: :heading,
          data: {
            text: 'School leader transforms Grantham primary school',
            level: :heading_one,
            bold: true
          }
        }]
      else
        case_study.name = 'Case Study - Meow Primary School'
        case_study.slug = 'case-study-meow-primary-school'
        case_study.hero_image = '//images.ctfassets.net/meow-hero-image.png'
        case_study.content = [{
          type: :heading,
          data: {
            text: 'School leader transforms Meow primary school',
            level: :heading_one,
            bold: true
          }
        }]
      end
    end
  end
end

describe UseCase::GetCaseStudy do
  let(:case_study_slug) { 'case-study-grantham-primary-school' }
  let(:contentful_gateway) { ContentfulGatewayStub.new }
  let(:get_case_study) do
    UseCase::GetCaseStudy.new(content_gateway: contentful_gateway)
  end
  let(:response) { get_case_study.execute(slug: case_study_slug) }

  before { response }

  it 'can call the contentful gateway' do
    expect(contentful_gateway.is_get_case_study_called).to be_truthy
  end

  it 'can call the contentful gateway with the slug' do
    expect(contentful_gateway.get_case_study_called_with).to eq(case_study_slug)
  end

  it 'can get the name of a case study from the gateway (example one)' do
    expect(response).to include(name: 'Case Study - Grantham Primary School')
  end

  it 'can get the name of a case study from the gateway (example two)' do
    case_study_slug = 'case-study-meow-primary-school'
    response = get_case_study.execute(slug: case_study_slug)

    expect(response).to include(name: 'Case Study - Meow Primary School')
  end

  it 'can get the slug of a case study from the gateway (example one)' do
    expect(response).to include(slug: 'case-study-grantham-primary-school')
  end

  it 'can get the slug of a case study from the gateway (example two)' do
    case_study_slug = 'case-study-meow-primary-school'
    response = get_case_study.execute(slug: case_study_slug)

    expect(response).to include(slug: 'case-study-meow-primary-school')
  end

  it 'can get the hero image of a case study from the gateway (example one)' do
    expect(response).to include(hero_image: '//images.ctfassets.net/grantham-hero-image.png')
  end

  it 'can get the hero image of a case study from the gateway (example two)' do
    case_study_slug = 'case-study-meow-primary-school'
    response = get_case_study.execute(slug: case_study_slug)

    expect(response).to include(hero_image: '//images.ctfassets.net/meow-hero-image.png')
  end

  it 'can get the content of a case study from the gateway (example one)' do
    expect(response).to include(
      content: [{
        type: :heading,
        data: {
          text: 'School leader transforms Grantham primary school',
          level: :heading_one,
          bold: true
        }
      }]
    )
  end

  it 'can get the content of a case study from the gateway (example two)' do
    case_study_slug = 'case-study-meow-primary-school'
    response = get_case_study.execute(slug: case_study_slug)

    expect(response).to include(
      content: [{
        type: :heading,
        data: {
          text: 'School leader transforms Meow primary school',
          level: :heading_one,
          bold: true
        }
      }]
    )
  end
end
