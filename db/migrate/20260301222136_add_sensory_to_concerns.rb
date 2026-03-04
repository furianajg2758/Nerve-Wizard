class AddSensoryToConcerns < ActiveRecord::Migration[8.1]
  def change
    add_column :concerns, :sensory, :text
  end
end
