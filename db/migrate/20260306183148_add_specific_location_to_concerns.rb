class AddSpecificLocationToConcerns < ActiveRecord::Migration[8.1]
  def change
    add_column :concerns, :specific_location, :string
  end
end
