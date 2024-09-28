class Api::V1::HomeController < Api::V1::ApplicationController

    
    def index
        bitcoin_price = Api::V1::CurrencyPriceService.bitcoin_price
        if bitcoin_price["value"]
            render json: { bitcoin_price: bitcoin_price["value"]}
        else
            render json: { error: "Ocurrió un error al procesar la solicitud: #{bitcoin_price["errors"]}" }, status: :internal_server_error
        end
    end

end