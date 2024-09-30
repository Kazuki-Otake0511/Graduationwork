class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :hobby
      t.string :hometown
      t.string :profile_image

      t.timestamps
    end
  end
end
