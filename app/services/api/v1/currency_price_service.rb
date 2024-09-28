class Api::V1::CurrencyPriceService
    include Api::V1::CurrencyHelper
    class << self
        include Api::V1::CurrencyHelper
    end


    def self.bitcoin_price
        bitcoin_price = {
            "value": nil,
            "errors": nil
        }
        begin
            currency = Api::V1::Currency.where(name: "BTC").first
            unless currency
                raise "El valor del bitcoin no esta disponible en el sistema, por favor cargarlo"
            end 
            response = RestClient.get currency.api_reference
            data = JSON.parse(response.body)
            bitcoin_price["value"] = format_value(data['bpi']['USD']['rate'], currency)
        rescue => e
            bitcoin_price["errors"] = e.message
        end
        bitcoin_price
    end

    
      
      



end