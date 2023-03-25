class ApplicationController < ActionController::API
  include ActionController::Cookies
    def authorize
        render json: { error: "Not authorized" }, status: 401 unless session.include? :user_id
    end

end
