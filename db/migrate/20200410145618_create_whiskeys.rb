class CreateWhiskeys < ActiveRecord::Migration[6.0]
  def change
    create_table :whiskey_brands do |t|
      t.string :name, { null: false }

      t.timestamps
    end

    create_table :whiskeys do |t|
      t.references :whiskey_brand, { null: false, foreign_key: true }
      t.string :label, { null: false }

      t.timestamps
    end
  end
end
