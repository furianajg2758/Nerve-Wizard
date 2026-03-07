class AddSpecificLocationToNerveReferences < ActiveRecord::Migration[8.1]
  def change
    add_column :nerve_references, :specific_location, :string
  end
end
