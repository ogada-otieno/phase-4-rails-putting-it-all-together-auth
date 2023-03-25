class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
    # skip_before_action :authorize, only: [:create]
    # handle signup
    def create
        if user_params[:password] == user_params[:password_confirmation]
             user = User.create!(user_params)
             session[:user_id] = user.id
             render json: user, status: 201
        else
             render json: { errors: "Unprocessable Entity" }, status: 422
        end
    end

    # handle auto-login
    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user, status: 201
        else
            render json: { error: "Unauthorized" }, status: 401
        end
    end

    private

    def user_params
        params.permit(:username, :password, :image_url, :bio, :password_confirmation)
    end

    def render_unprocessable_entity(invalid)
        render json: { errors: invalid.record.errors }
    end

    # def authorize
    #     render json: { error: "Not authorized" }, status: 401 unless session.include? :user_id
    # end
end
