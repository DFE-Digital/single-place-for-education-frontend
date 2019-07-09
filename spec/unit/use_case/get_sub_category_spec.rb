require 'rails_helper'

describe UseCase::GetSubCategory do
  let(:slug) { nil }
  let(:contentful_gateway) { spy }
  let(:get_sub_category) do
    UseCase::GetSubCategory.new(content_gateway: contentful_gateway)
  end
  let(:response) { get_sub_category.execute(slug: slug) }

  before { response }

  it 'can call the contentful gateway' do
    expect(contentful_gateway).to have_received(:get_sub_category)
  end

  context 'When sub-category is Supporting early career cats (example one)' do
    let(:slug) { 'supporting-early-career-cats' }
    let(:sub_category) do
      Domain::SubCategory.new.tap do |sub_category|
        sub_category.title = 'Supporting early career cats'
        sub_category.slug = slug
        sub_category.collection_name = 'Guidance'
        sub_category.breadcrumbs = [
          {
            text: 'Home',
            url: '/'
          },
          {
            text: 'Hiring and Cat Development',
            url: '/category/hiring'
          }
        ]
        sub_category.description = [{
          type: :rich_text,
          data: {
            html_content: '<p>Starting in September 2020 is the Early Career Framework (ECF). The ECF is a 2-year fully funded programme to help support newly qualified cats.</p>'
          }
        }]
        sub_category.content = [{
          type: :heading,
          data: {
            text: 'Cat Standards',
            level: :heading_two,
            bold: false,
            alignment: 'Left'
          }
        }]
      end
    end
    let(:contentful_gateway) { double(get_sub_category: sub_category) }

    it 'can call the contentful gateway with the slug' do
      expect(contentful_gateway).to have_received(:get_sub_category).with(slug: slug)
    end

    it 'can return the title of a sub-category' do
      expect(response[:title]).to eq('Supporting early career cats')
    end

    it 'can return the slug of a sub-category' do
      expect(response[:slug]).to eq(slug)
    end

    it 'can return the collection name of a sub-category' do
      expect(response[:collection_name]).to eq('Guidance')
    end

    it 'can return the breadcrumbs of a sub-category' do
      expect(response[:breadcrumbs]).to eq([
        {
          text: 'Home',
          url: '/'
        },
        {
          text: 'Hiring and Cat Development',
          url: '/category/hiring'
        }
      ])
    end

    it 'can return the description of a sub-category' do
      expect(response[:description]).to eq([
        {
          type: :rich_text,
          data: {
            html_content: '<p>Starting in September 2020 is the Early Career Framework (ECF). The ECF is a 2-year fully funded programme to help support newly qualified cats.</p>'
          }
        }
      ])
    end

    it 'can return the content of a sub-category' do
      expect(response[:content]).to eq([
        {
          type: :heading,
          data: {
            text: 'Cat Standards',
            level: :heading_two,
            bold: false,
            alignment: 'Left'
          }
        }
      ])
    end
  end

  context 'When sub-category is Supporting early career dogs (example two)' do
    let(:slug) { 'supporting-early-career-dogs' }
    let(:sub_category) do
      Domain::SubCategory.new.tap do |sub_category|
        sub_category.title = 'Supporting early career dogs'
        sub_category.slug = slug
        sub_category.collection_name = 'Article'
        sub_category.breadcrumbs = [
          {
            text: 'Home',
            url: '/'
          },
          {
            text: 'Hiring and Dog Development',
            url: '/category/hiring'
          }
        ]
        sub_category.description = [{
          type: :rich_text,
          data: {
            html_content: '<p>Starting in September 2099 is the Early Career Framework (ECF). The ECF is a 2-year fully funded programme to help support newly qualified dogs.</p>'
          }
        }]
        sub_category.content = [{
          type: :heading,
          data: {
            text: 'Dog Standards',
            level: :heading_two,
            bold: false,
            alignment: 'Left'
          }
        }]
      end
    end
    let(:contentful_gateway) { double(get_sub_category: sub_category) }

    it 'can call the contentful gateway with the slug' do
      expect(contentful_gateway).to have_received(:get_sub_category).with(slug: slug)
    end

    it 'can return the title of a sub-category' do
      expect(response[:title]).to eq('Supporting early career dogs')
    end

    it 'can return the slug of a sub-category' do
      expect(response[:slug]).to eq(slug)
    end

    it 'can return the collection name of a sub-category' do
      expect(response[:collection_name]).to eq('Article')
    end

    it 'can return the breadcrumbs of a sub-category' do
      expect(response[:breadcrumbs]).to eq([
        {
          text: 'Home',
          url: '/'
        },
        {
          text: 'Hiring and Dog Development',
          url: '/category/hiring'
        }
      ])
    end

    it 'can return the description of a sub-category' do
      expect(response[:description]).to eq([
        {
          type: :rich_text,
          data: {
            html_content: '<p>Starting in September 2099 is the Early Career Framework (ECF). The ECF is a 2-year fully funded programme to help support newly qualified dogs.</p>'
          }
        }
      ])
    end

    it 'can return the content of a sub-category' do
      expect(response[:content]).to eq([
        {
          type: :heading,
          data: {
            text: 'Dog Standards',
            level: :heading_two,
            bold: false,
            alignment: 'Left'
          }
        }
      ])
    end
  end

  context 'When no sub-category is found' do
    let(:sub_category) { nil }
    let(:slug) { 'supporting-early-career-penguins' }
    let(:contentful_gateway) { double(get_sub_category: sub_category) }

    it 'can handle when the gateway returns nil' do
      response = get_sub_category.execute(slug: slug)

      expect(response).to eq(nil)
    end
  end
end
