class RecipesController < ApplicationController
  def index
  	@keyword = params["search"] || "chocolate"
  	@recipes = Recipe.for(@keyword)
  	puts @recipes
  end
end
