class Api::V1::AuthenticationController < Api::V1::ApplicationController

    skip_before_action :authenticate_request, only: [:login]

    #POST /auth/login
    def login
        @user = Api::V1::User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
            token = jwt_encode(user_id: @user.id)
            render json: {token: token}, status: :ok
        else
            render json: {error: 'Usuario invalido o contraseña invalida'}, status: :unauthorized
        end
    end

end
