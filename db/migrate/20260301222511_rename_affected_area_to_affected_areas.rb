class RenameAffectedAreaToAffectedAreas < ActiveRecord::Migration[8.1]
  def change
    rename_column(:concerns, :affected_area, :affected_areas)
  end
end
