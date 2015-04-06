json.(day,:date)
json.meals day[:meals], partial: '/meals/meal', as: :meal

