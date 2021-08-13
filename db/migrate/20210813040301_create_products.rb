class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :title
      t.integer :price
      t.string :category
      t.string :region
      t.string :commune

      t.timestamps
    end
  end
end
