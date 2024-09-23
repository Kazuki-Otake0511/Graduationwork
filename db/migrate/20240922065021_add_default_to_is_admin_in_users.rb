class AddDefaultToIsAdminInUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_default :users, :is_admin, false
  end
end
