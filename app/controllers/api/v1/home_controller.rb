class Api::V1::HomeController < Api::V1::ApplicationController

    api :GET, '/v1', 'Obtener el precio actual del Bitcoin en USD'
    description 'Devuelve el precio actual del Bitcoin en dólares estadounidenses (USD). Se requiere autenticación mediante un token JWT en el header.'
    header 'Authorization', 'Bearer token JWT', required: true
    error code: 401, desc: 'No autorizado'
    error code: 500, desc: 'Error interno del servidor'
    def index
        bitcoin_price = Api::V1::CurrencyPriceService.bitcoin_price
        if bitcoin_price["value"]
            render json: { bitcoin_price: bitcoin_price["value"]}
        else
            render json: { error: "Ocurrió un error al procesar la solicitud: #{bitcoin_price["errors"]}" }, status: :internal_server_error
        end
    end

end