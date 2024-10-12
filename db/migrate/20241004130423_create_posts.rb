class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :product_name
      t.integer :product_rank
      t.text :recommendation_points
      t.string :purchase_link
      t.string :product_video

      t.timestamps
    end
  end
end
