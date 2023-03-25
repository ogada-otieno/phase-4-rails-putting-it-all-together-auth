class RecipesController < ApplicationController
    before_action :authorize
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :unauthorized_response

    # view recipes for a specific user
    def index
        user = User.find(session[:user_id])
        if user
            recipes = user.recipes
            render json: recipes, status: 201
        else
            render json: { error: "Unauthorized" }, status: 401
        end
    end

    # lets a user create a new recipe
    def create
        user = User.find_by(id: session[:user_id])
        # if user
            recipe = user.recipes.create!(recipe_params)
            render json: recipe, status: 201
        # else
        #     render json: { errors: "Unauthorized" }, status: 401
        # end
    end

    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def render_unprocessable_entity(invalid)
        render json: { error: invalid.record.errors.full_messages }, status: 422
    end

    def unauthorized_response
        render json: { error: "User is not authorized"}, status: 401 #unless session.include? :user_id
    end
end
