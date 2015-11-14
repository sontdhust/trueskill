class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.float :mean
      t.float :standard_deviation

      t.timestamps null: false
    end
  end
end
