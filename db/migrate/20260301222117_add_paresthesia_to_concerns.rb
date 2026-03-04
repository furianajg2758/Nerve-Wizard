class AddParesthesiaToConcerns < ActiveRecord::Migration[8.1]
  def change
    add_column :concerns, :paresthesia, :text
  end
end
