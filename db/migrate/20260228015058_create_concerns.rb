class CreateConcerns < ActiveRecord::Migration[8.1]
  def change
    create_table :concerns do |t|
      t.string :affected_area
      t.text :symptoms

      t.timestamps
    end
  end
end
