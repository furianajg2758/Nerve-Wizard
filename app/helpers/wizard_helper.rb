module WizardHelper
def generate_clinical_note(area, p, s, w, r, nerve_names)
  # 1. Force nerve_names to be an array so .to_sentence works
  names_array = Array(nerve_names)
  is_tie = names_array.size > 1
  
  # 2. Format the names: "Nerve A" OR "Nerve A and Nerve B"
  nerve_text = names_array.to_sentence
  
  # 3. Build the subjective portion
  # Ensure p and s are arrays, flatten them, remove blanks/nils, and get unique values
  symptoms = [Array(p), Array(s)].flatten.reject(&:blank?).uniq
  subjective_text = symptoms.any? ? symptoms.to_sentence : "unspecified symptoms"
  
  subjective = "Patient reports symptoms in the #{area} region, specifically: #{subjective_text}"
  
  # 4. Change language based on whether it's a tie
  assessment = is_tie ? "Differential diagnosis includes " : "Clinical presentation is consistent with "
  assessment += "involvement of the #{nerve_text}."
  
  "#{subjective}. #{assessment}"
end
end
