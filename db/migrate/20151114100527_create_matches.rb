class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :home_id
      t.integer :away_id
      t.string :result, :limit => 1, :null => false
      t.string :date
      t.string :year

      t.timestamps null: false
    end
  end
end
