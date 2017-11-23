class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.references :services, foreign_key: true
      t.integer :line_item_id, limit: 5 # bigint
      t.timestamps
    end

    # add unique indexes
    add_index :posts, [:services_id, :line_item_id], unique: true
  end
end
