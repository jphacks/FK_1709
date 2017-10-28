class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.references :chat, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :message_type
      t.text :text
      t.string :image

      t.timestamps
    end
  end
end
