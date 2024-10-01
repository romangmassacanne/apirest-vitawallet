class Api::V1::UsersController < Api::V1::ApplicationController
  before_action :set_user, only: %i[ show destroy]
  skip_before_action :authenticate_request, only: [:create]

  api :GET, '/v1/users', 'Obtener todos los usuarios'
  description 'Devuelve una lista de todos los usuarios registrados en el sistema. Se requiere autenticación mediante un token JWT en el header.'
  header 'Authorization', 'Bearer token JWT', required: true
  error code: 401, desc: 'No autorizado'
  def index
    @users = Api::V1::User.all
    render json: @users
  end

  api :GET, '/v1/users/:id', 'Obtener un usuario por ID'
  description 'Devuelve los detalles de un usuario específico identificado por su ID. Se requiere autenticación mediante un token JWT en el header.'
  header 'Authorization', 'Bearer token JWT', required: true
  param :id, :number, desc: 'ID del usuario a obtener', required: true
  error code: 401, desc: 'No autorizado'
  error code: 404, desc: 'Usuario no encontrado'
  def show
    render json: @user
  end

  api :POST, '/v1/users', 'Crear un nuevo usuario'
  description 'Crea un nuevo usuario en el sistema. Al crearse, el usuario recibe una cuenta en USD con 10,000 USD.'
  param :username, String, desc: 'Nombre de usuario', required: true
  param :email, String, desc: 'Correo electrónico del usuario', required: true
  param :password, String, desc: 'Contraseña del usuario', required: true
  error code: 422, desc: 'Error de validación'
  example '
    {
      "user": {
        "username": "string",
        "email": "string",
        "password": "string"
      }
    }
  '
  # Se crea por default con una cuenta en dolares, a modo de ejemplo se le coloca 10000 usd para empezar
  def create
    @user = Api::V1::User.new(user_params)
    if @user.save
      currency = Api::V1::Currency.find_by(name: "USD")
      currency_account = Api::V1::CurrencyAccount.new(user_id: @user.id, currency_id: currency.id, balance: 10000)
      if currency_account.save
        render json: @user, status: :created, location: @user
      else
        @user.destroy!
        render json: currency_account.errors, status: :unprocessable_entity
      end 
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end


  api :DELETE, '/v1/users/:id', 'Eliminar un usuario por ID'
  description 'Elimina un usuario específico identificado por su ID. Se requiere autenticación mediante un token JWT en el header.'
  header 'Authorization', 'Bearer token JWT', required: true
  param :id, :number, desc: 'ID del usuario a eliminar', required: true
  error code: 401, desc: 'No autorizado'
  error code: 404, desc: 'Usuario no encontrado'
  def destroy
    @user.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = Api::V1::User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end
end
