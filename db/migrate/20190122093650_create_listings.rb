class CreateListings < ActiveRecord::Migration[5.2]
  def change
    create_table :listings do |t|

      t.string :name, null: false
      t.string :description, null: false
      t.string :address, null: false
      t.string :state, null: false
      t.string :country, null: false
      t.integer :number_of_beds, null: false
      t.integer :price, null: false
      t.date :available_from, null: false
      t.date :available_to, null: false
      t.references :user, foreign_key: true
      t.timestamps

    end
  end
end
