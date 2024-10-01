class Api::V1::CurrenciesController < Api::V1::ApplicationController


  api :GET, '/v1/currencies', 'Obtener todas las monedas'
  description 'Devuelve una lista de todas las monedas disponibles en el sistema. Se requiere autenticación mediante un token JWT en el header.'
  header 'Authorization', 'Bearer token JWT', required: true
  error code: 401, desc: 'No autorizado'
  def index
    @currencies = Api::V1::Currency.all
    render json: @currencies
  end
  
end
