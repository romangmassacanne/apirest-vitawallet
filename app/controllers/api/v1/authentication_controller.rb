class Api::V1::AuthenticationController < Api::V1::ApplicationController

    skip_before_action :authenticate_request, only: [:login]

    api :POST, '/v1/auth/login', 'Iniciar sesión de usuario'
    description 'Permite a un usuario iniciar sesión y obtener un token JWT para autenticación en futuros requests.'
    param :email, String, desc: 'Correo electrónico del usuario', required: true
    param :password, String, desc: 'Contraseña del usuario', required: true
    example '
    {
        "token": "eyJhbGciOiJIUzI1NiJ9..."
    }'
    error code: 401, desc: 'Usuario inválido o contraseña incorrecta'
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
