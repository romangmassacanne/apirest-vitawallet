class Api::V1::TransactionsController < Api::V1::ApplicationController
    include Api::V1::CurrencyHelper
  
    before_action :set_transaction, only: %i[ show ]

  
    api :GET, '/v1/transactions', 'Obtener todas las transacciones del usuario logueado'
    description 'Devuelve una lista de todas las transacciones realizadas por el usuario logueado. Se requiere autenticación mediante un token JWT en el header.'
    header 'Authorization', 'Bearer token JWT', required: true
    error code: 401, desc: 'No autorizado'
    error code: 500, desc: 'Error interno del servidor'
    def index
        formatted_transactions = @current_user.transactions.map do |transaction|
            format_transaction(transaction)
        end
        render json: formatted_transactions
    end 


    api :GET, '/v1/transactions/:id', 'Obtener una transacción por ID'
    description 'Devuelve los detalles de una transacción específica por su ID. Se requiere autenticación mediante un token JWT en el header.'
    header 'Authorization', 'Bearer token JWT', required: true
    param :id, :number, desc: 'El ID de la transacción', required: true
    error code: 401, desc: 'No autorizado'
    error code: 404, desc: 'Transacción no encontrada'
    def show
        render json: format_transaction(@transaction)
    end


    api :POST, '/v1/transactions', 'Crear una nueva transacción'
    description 'Crea una nueva transacción. Se requiere autenticación mediante un token JWT en el header.'
    header 'Authorization', 'Bearer token JWT', required: true
    param :currency_from, String, desc: 'La moneda de origen (ej: USD)', required: true
    param :currency_to, String, desc: 'La moneda de destino (ej: BTC)', required: true
    param :amount_from, Float, desc: 'El monto de la moneda de origen a convertir', required: true
    error code: 401, desc: 'No autorizado'
    error code: 422, desc: 'Error de validación'
    error code: 404, desc: 'Saldo insuficiente o recurso no encontrado'
    example '
    {
        "transaction": {
            "currency_from": "USD",
            "currency_to": "BTC",
            "amount_from": 100
        }
    }'
    # POST /transactions
    # Para esta transacción como se puede ver no hay seguridad en caso de que falle por alguna razon y el user pueda perder el dinero
    # no se modelo porque por el alcance de la app no se consideró escencial 
    def create
        permitted_params = transaction_params
        currency_from = Api::V1::Currency.find_by(name: permitted_params[:currency_from])
        currency_to = Api::V1::Currency.find_by(name: permitted_params[:currency_to])
        amount_from = permitted_params[:amount_from]
        unless amount_from.is_a?(Float)
            amount_from = amount_from.to_f
        end

        user_currency_account = @current_user.currency_accounts.find_by(currency_id: currency_from.id) if currency_from
        if user_currency_account && user_currency_account.has_enough_money?(amount_from)
            amount_to = Api::V1::Currency.calculate_value(currency_from, currency_to, amount_from) 
            @transaction = Api::V1::Transaction.new(currency_from: currency_from, currency_to: currency_to, amount_from: amount_from, amount_to: amount_to, user_id: @current_user.id)
            if user_currency_account.save_balances(amount_from, amount_to, currency_to) && @transaction.save
                render json: format_transaction(@transaction), status: :created
            else
                erros = @transaction.errors.full_messages + user_currency_account.errors.full_messages
                render json: erros, status: :unprocessable_entity
            end
        else
            render json: { error: "El usuario no posee suficiente saldo para realizar la transacción" }
        end
    end



    private

    # Lo idea no seria formatear la transacción aca, seria usando una gema como jbuilder o un serialize pero viendo el alcance de la app se opto por esto
    def format_transaction(transaction)
        amount_from = format_value(transaction.amount_from, transaction.currency_from)
        amount_to = format_value(transaction.amount_to, transaction.currency_to)
        {
          id: transaction.id,
          currency_from: transaction.currency_from.name,
          currency_to: transaction.currency_to.name,
          amount_from: amount_from,
          amount_to: amount_to
        }
    end

    def transaction_params
        params.require(:transaction).permit(:currency_from, :currency_to, :amount_from)
    end

    def set_transaction
        @transaction = Api::V1::Transaction.find(params[:id])
      end
end
