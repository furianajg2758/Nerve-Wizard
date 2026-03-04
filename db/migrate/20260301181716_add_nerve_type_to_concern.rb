class AddNerveTypeToConcern < ActiveRecord::Migration[8.1]
  def change
    add_column :concerns, :nerve_type, :string
  end
end
