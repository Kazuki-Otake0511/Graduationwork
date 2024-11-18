class ChangePurchaseLinkToTextInPosts < ActiveRecord::Migration[7.2]
  def change
    change_column :posts, :purchase_link, :text
  end
end
