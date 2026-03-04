class CreateNerveReferences < ActiveRecord::Migration[8.1]
  def change
    create_table :nerve_references do |t|
      t.string :name
      t.text :affected_areas
      t.text :paresthesia
      t.text :sensory
      t.text :weakness
      t.text :reflexes

      t.timestamps
    end
  end
end
