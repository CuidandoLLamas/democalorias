class MealsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def index
    @meals=nil
    
    if params[:date_from] and params[:date_to]
      #TODO catch invalid date/time format error, see how timezone are handled, might be good to have it set up at User level
      
      #TODO see how to handle case in which date_to is in the past and date_from in the future
      date_from=DateTime.parse(params[:date_from])
      date_to=DateTime.parse(params[:date_to])
      
      @meals=Meal.date_range_query_ordered_by_date(date_from,date_to)
    else
      #No filtering we return no meals
      @meals=nil
    end
  end

  def show
    @meal = Meal.find(params[:id])
  end

  def destroy
    @meal = Meal.find(params[:id])
    @meal.destroy
    head :no_content
  end

  def create
    @meal = Meal.new(params.require(:meal).permit(:description,:moment,:calories))
    @meal.save
    render 'show', status: 201
  end

  def update
    @meal = Meal.new(params.require(:meal).permit(:description,:moment,:calories))
    @meal.save
    render 'show', status: 201
  end

  def update
    meal = Meal.find(params[:id])
    meal.update_attributes(params.require(:meal).permit(:description,:moment,:calories))
    head :no_content
  end
end
