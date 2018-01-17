class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
    add_index :microposts, [:created_at]
  end
end
