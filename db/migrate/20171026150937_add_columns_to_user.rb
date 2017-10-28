class AddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string
    add_column :users, :sex, :integer
    add_column :users, :birthday, :date        
    add_column :users, :married_status, :integer
    add_column :users, :sibling , :integer
    add_column :users, :job, :string
    add_column :users, :income, :integer
    add_column :users, :uid, :integer, limit: 8
    add_column :users, :provider, :string
    add_column :users, :token, :string
  end
end
