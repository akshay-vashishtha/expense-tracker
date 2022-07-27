class ApplicationController < ActionController::API
    include Pundit
    def json_payload
        HashWithIndifferentAccess.new(JSON.parse(request.raw_post))
    end

    def authorize_admin
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @decoded = JsonWebToken.decode(header)
          Current.user = Admin.find_by(user_handle: @decoded[:user_handle])
        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :unauthorized
        rescue JWT::DecodeError => e
          render json: { errors: e.message }, status: :unauthorized
        end
    end

    def authorize_employee
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      begin
        @decoded = JsonWebToken.decode(header)
        Current.user = Employee.find_by(user_handle: @decoded[:user_handle])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
  end

    private
    def current_user
      current_user = Current.user
    end
end
