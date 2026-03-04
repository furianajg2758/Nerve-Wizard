class NerveReference < ApplicationRecord
  serialize :affected_areas, type: Array, coder: JSON
  serialize :paresthesia, type: Array, coder: JSON
  serialize :sensory, type: Array, coder: JSON 
  serialize :weakness, type: Array, coder: JSON
  serialize :reflexes, type: Array, coder: JSON


end
