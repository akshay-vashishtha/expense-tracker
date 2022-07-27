class Api::AuthenticationController < ApplicationController
    # before_action :authorize_admin, except: [:login_admin, :login_admin]

    # POST /auth/login_admin
    def login_admin
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

    # POST /auth/login_employee
    def login_employee
      data = json_payload
      @employee = Employee.find_by(user_handle: data[:user_handle])
      if @employee&.authenticate(data[:password])
        token = JsonWebToken.encode(user_handle: @employee.user_handle, password: @employee.password_digest)
        time = Time.now + 24.hours.to_i
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                       username: @employee.user_handle }, status: :ok
      else
        render json: { error: 'unauthorized' }, status: :unauthorized
      end
    end

    private
  
    def login_params
      params.permit(:user_handle, :password)
    end
end
