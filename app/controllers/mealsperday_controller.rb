class MealsperdayController < ApplicationController
  def index
    @days=nil
    
    if params[:date_from] and params[:date_to]
      #TODO catch invalid date/time format error, see how timezone are handled, might be good to have it set up at User level
      

      #TODO see how to handle case in which date_to is in the past and date_from in the future
      date_from=Date.strptime(params[:date_from], '%d/%m/%Y')
      date_to=Date.strptime(params[:date_to], '%d/%m/%Y')

      meals=Meal.date_range_query_ordered_by_date(date_from,date_to+1)
      mealCount=meals.count
      current_meal_index=0

      @days=[]
      #We'll loop over from start date til end_date
      date_from.step(date_to) do | date |
        day={date: date}
        meals_a_day=[]

        #Meals are ordered by date in ascending order so we can loop trough the ones that correspond to
        #this date if any and keep the index to continue looping for next date that has meals
        while current_meal_index<mealCount and meals[current_meal_index].moment.to_date==date
          meals_a_day.push(meals[current_meal_index])
          current_meal_index=current_meal_index+1
        end

        day[:meals]=meals_a_day
        @days.push(day)
      end
      
      logger.debug @days.to_json
    else
      #No filtering we return no days
      @days=nil
    end
  end
end
