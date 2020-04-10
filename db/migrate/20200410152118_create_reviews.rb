class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.references :whiskey, { null: false, foreign_key: true }
      t.references :user, { null: false, foreign_key: true }
      t.string :title
      t.text :description
      t.integer :taste_grade
      t.integer :color_grade
      t.integer :smokiness_grade

      t.timestamps
    end
  end
end
