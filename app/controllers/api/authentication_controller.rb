class Api::AuthenticationController < ApplicationController
    before_action :authorize_request, except: :login

    # POST /auth/login
    def login
      data = json_payload
      @admin = Admin.find_by(user_handle: data[:user_handle])
      if @admin&.authenticate(data[:password])
        token = JsonWebToken.encode(user_handle: @admin.user_handle, password: @admin.password_digest)
        time = Time.now + 24.hours.to_i
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                       username: @admin.user_handle }, status: :ok
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    end
  
    private
  
    def login_params
      params.permit(:user_handle, :password)
    end
end
