require 'spec_helper'

describe MealsController do
  render_views
  describe "index with date_from date_to filtering" do
    before do
      Meal.create!(calories:1021, description: 'Baked Potato w/ Cheese',moment: '10/10/2014 10:10:00')
      Meal.create!(calories:1214, description: 'Garlic Mashed Potatoes',moment: '11/10/2014 10:10:00')
      Meal.create!(calories:5621, description: 'Potatoes Au Gratin',moment: '12/10/2014 10:10:00')
      Meal.create!(calories:2689, description: 'Baked Brussel Sprouts',moment: '13/10/2014 10:10:00')

      xhr :get, :index, format: :json, date_from: date_from,date_to: date_to
      
    end

    subject(:results) { JSON.parse(response.body) }

    def extract_description
      ->(object) { object["description"] }
    end
    
    context "when the search uses date from to filter" do
      let(:date_from) { '10/10/2014 10:10:00' }
      let(:date_to) { '11/10/2014 10:10:00' }
      it 'should 200' do
        expect(response.status).to eq(200)
      end
      it 'should return two results' do
        expect(results.size).to eq(2)
      end
      it "should include 'Baked Potato w/ Cheese'" do
        expect(results.map(&extract_description)).to include('Baked Potato w/ Cheese')
      end
      it "should include 'Garlic Mashed Potatoes'" do
        expect(results.map(&extract_description)).to include('Garlic Mashed Potatoes')
      end
    end

    context "when the search uses date from to filter but there are no matching records" do
      let(:date_from) { '10/10/2013 10:10:00' }
      let(:date_to) { '11/10/2013 10:10:00' }
      it 'should return no results' do
        expect(results.size).to eq(0)
      end
    end
  end
  
  
  describe "index" do
    before do
      Meal.create!(calories:1021, description: 'Baked Potato w/ Cheese',moment: '10/10/2014 10:10:00')
      Meal.create!(calories:1214, description: 'Garlic Mashed Potatoes',moment: '11/10/2014 10:10:00')
      Meal.create!(calories:5621, description: 'Potatoes Au Gratin',moment: '12/10/2014 10:10:00')
      Meal.create!(calories:2689, description: 'Baked Brussel Sprouts',moment: '13/10/2014 10:10:00')

      xhr :get, :index, format: :json
      
    end

    subject(:results) { JSON.parse(response.body) }

    def extract_description
      ->(object) { object["description"] }
    end
    
    context "when no search param " do
      it 'should return no results' do
        expect(results.size).to eq(4)
      end
    end
  end
end
