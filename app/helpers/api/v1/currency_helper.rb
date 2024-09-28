module Api::V1::CurrencyHelper

    def format_value(amount, currency)
        ActionController::Base.helpers.number_to_currency(
          amount,
          unit: currency.name,
          separator: ',',
          delimiter: '.',
          precision: currency.precision,
          format: "%n %u"  
        )
    end

end 