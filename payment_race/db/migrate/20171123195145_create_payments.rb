class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :service, foreign_key: true
      t.integer :line_item_id, limit: 5 # bigint
      t.timestamps
    end

    # add unique indexes
    add_index :payments, :line_item_id, unique: true
    add_index :payments, [:service_id, :line_item_id], unique: true
  end
end
