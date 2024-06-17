class CreateAuthors < ActiveRecord::Migration[7.1]
  def change
    create_table :authors do |t|
      t.string :full_name, null: false, default: ""
      t.string :bio,       null: false, default: ""

      t.timestamps null: false
    end
  end
end
