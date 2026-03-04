class AddWeaknessToConcerns < ActiveRecord::Migration[8.1]
  def change
    add_column :concerns, :weakness, :text
  end
end
