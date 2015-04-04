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
        expect(results.size).to eq(0)
      end
    end
  end


  describe "show" do
    before do
      xhr :get, :show, format: :json, id: meal_id
    end

    subject(:results) { JSON.parse(response.body) }

    context "when the meal exists" do
      let(:meal) { 
        Meal.create!(description: 'Baked Potato w/ Cheese', 
               calories: 12123,
               moment: DateTime.now) 
      }
      let(:meal_id) { meal.id }

      it { expect(response.status).to eq(200) }
      it { expect(results["id"]).to eq(meal.id) }
      it { expect(results["description"]).to eq(meal.description) }
      it { expect(results["calories"]).to eq(meal.calories) }
      it { expect(results["moment"]).to eq(meal.moment.iso8601) }
    end

    context "when the meal doesn't exit" do
      let(:meal_id) { -9999 }
      it { expect(response.status).to eq(404) }
    end
  end

  describe "create" do

    m=DateTime.now - 1000
    puts "Moment being used to create:" + m.iso8601
    Rails.logger.debug "Moment being used to create:" + m.iso8601
    before do
      xhr :post, :create, format: :json, meal: 
        { 
          description: "Toast", 
          calories: 12134,
          moment: m
        }
    end

    it { expect(response.status).to eq(201) }
    it { expect(Meal.last.description).to eq("Toast") }
    it { expect(Meal.last.calories).to eq(12134) }
    it { expect(Meal.last.moment.iso8601).to eq(m.iso8601) }
  end

=begin
  describe "update" do
    let(:meal) { 
      Meal.create!(name: 'Baked Potato w/ Cheese', 
                     instructions: "Nuke for 20 minutes; top with cheese") 
    }


    before do
      xhr :put, :update, format: :json, id: meal.id, meal: { name: "Toast", 
                                                 instructions: "Add bread to toaster, push lever" }
      meal.reload
    end
    it { expect(response.status).to eq(204) }
    it { expect(meal.name).to eq("Toast") }
    it { expect(meal.instructions).to eq("Add bread to toaster, push lever") }
  end

  describe "destroy" do
    let(:meal_id) { 
      Meal.create!(name: 'Baked Potato w/ Cheese', 
                     instructions: "Nuke for 20 minutes; top with cheese").id
    }
    before do
      xhr :delete, :destroy, format: :json, id: meal_id
    end
    it { expect(response.status).to eq(204) }
    it { expect(Meal.find_by_id(meal_id)).to be_nil }
  end
=end
end
