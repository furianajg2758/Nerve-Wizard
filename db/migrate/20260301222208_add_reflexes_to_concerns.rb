class AddReflexesToConcerns < ActiveRecord::Migration[8.1]
  def change
    add_column :concerns, :reflexes, :text
  end
end
