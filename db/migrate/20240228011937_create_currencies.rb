class CreateCurrencies < ActiveRecord::Migration[7.1]
  def change
    create_table :currencies do |t|
      t.string :name, null: false
      t.string :api_reference
      t.integer :precision, null: false
    end
  end
end
