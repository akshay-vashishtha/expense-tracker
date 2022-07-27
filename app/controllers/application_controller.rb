class ApplicationController < ActionController::API
    include Pundit::Authorization
    def json_payload
        HashWithIndifferentAccess.new(JSON.parse(request.raw_post))
    end
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @current_user = Admin.find_by(user_handle: @decoded[:user_handle])
        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: { errors: e.message }, status: :unauthorized
        end
    end

    private
    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_back(fallback_location: root_path)
    end

    # def current_user
    #     current_user = Current.user
    # end
end