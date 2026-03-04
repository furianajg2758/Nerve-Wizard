class AddNerveTypeToNerveReference < ActiveRecord::Migration[8.1]
  def change
    add_column :nerve_references, :nerve_type, :string
  end
end
