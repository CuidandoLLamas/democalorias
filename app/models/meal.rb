class Meal < ActiveRecord::Base
  def self.date_range_query_ordered_by_date(date_from,date_to)
     Meal.where('moment between ? and ?',date_from,date_to).order("moment ASC")
  end
end
