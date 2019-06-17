# frozen_string_literal: true

require 'rails_helper'

describe UseCase::GetCaseStudy do
  let(:case_study_slug) { nil }
  let(:contentful_gateway) { spy }
  let(:get_case_study) do
    UseCase::GetCaseStudy.new(content_gateway: contentful_gateway)
  end
  let(:response) { get_case_study.execute(slug: case_study_slug) }

  before { response }

  it 'can call the contentful gateway' do
    expect(contentful_gateway).to have_received(:get_case_study)
  end

  context 'When case study is Woof Primary School' do
    let(:case_study) do
      Domain::CaseStudy.new.tap do |case_study|
        case_study.name = 'Case Study - Woof Primary School'
        case_study.slug = 'case-study-woof-primary-school'
        case_study.hero_image = '//images.ctfassets.net/woof-hero-image.png'
        case_study.content = [{
          type: :heading,
          data: {
            text: 'School leader transforms Woof primary school',
            level: :heading_one,
            bold: true
          }
        }]
      end
    end
    let(:case_study_slug) { 'case-study-woof-primary-school' }
    let(:contentful_gateway) { double(get_case_study: case_study) }

    it 'can call the contentful gateway with the slug' do
      expect(contentful_gateway).to have_received(:get_case_study).with(slug: case_study_slug)
    end

    it 'can get the name of a case study from the gateway (example one)' do
      expect(response).to include(name: 'Case Study - Woof Primary School')
    end

    it 'can get the slug of a case study from the gateway (example one)' do
      expect(response).to include(slug: 'case-study-woof-primary-school')
    end

    it 'can get the hero image of a case study from the gateway (example one)' do
      expect(response).to include(hero_image: '//images.ctfassets.net/woof-hero-image.png')
    end

    it 'can get the content of a case study from the gateway (example one)' do
      expect(response).to include(
        content: [{
          type: :heading,
          data: {
            text: 'School leader transforms Woof primary school',
            level: :heading_one,
            bold: true
          }
        }]
      )
    end
  end

  context 'When case study is Meow Primary School' do
    let(:case_study) do
      Domain::CaseStudy.new.tap do |case_study|
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
    let(:case_study_slug) { 'case-study-meow-primary-school' }
    let(:contentful_gateway) { double(get_case_study: case_study) }

    it 'can call the contentful gateway with the slug' do
      expect(contentful_gateway).to have_received(:get_case_study).with(slug: case_study_slug)
    end

    it 'can get the name of a case study from the gateway (example two)' do
      response = get_case_study.execute(slug: case_study_slug)

      expect(response).to include(name: 'Case Study - Meow Primary School')
    end

    it 'can get the slug of a case study from the gateway (example two)' do
      response = get_case_study.execute(slug: case_study_slug)

      expect(response).to include(slug: 'case-study-meow-primary-school')
    end

    it 'can get the hero image of a case study from the gateway (example two)' do
      response = get_case_study.execute(slug: case_study_slug)

      expect(response).to include(hero_image: '//images.ctfassets.net/meow-hero-image.png')
    end

    it 'can get the content of a case study from the gateway (example two)' do
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

  context 'When no case study is found' do
    let(:case_study) { nil }
    let(:case_study_slug) { 'case-study-hoot-primary-school' }
    let(:contentful_gateway) { double(get_case_study: case_study) }

    it 'can handle when the gateway returns nil' do
      response = get_case_study.execute(slug: case_study_slug)
      expect(response).to eq(nil)
    end
  end
end
