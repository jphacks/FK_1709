class AddPostDataToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :post_data, :text, limit: 4294967295
    add_column :users, :recommend_text, :text, limit: 4294967295
    add_column :users, :profile, :text, limit: 4294967295
  end
end
