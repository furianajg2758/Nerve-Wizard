module ClinicalNoteHelper
  def generate_clinical_note(area, paresthesia, sensory, weakness, reflexes, top_nerve)
    sections = []

clean_raw = ->(list) { 
  Array(list).flatten
             .map { |i| i.to_s.strip } # Strip first to find "blank" strings
             .reject { |i| i.blank? || i.downcase == "none" }
             .uniq 
}

    # 1. New 'smart_join' helper to handle the semicolon formatting
    smart_join = ->(list) {
      return nil if list.empty?
      # We lowercase and titleize for consistency
      list.map(&:downcase).uniq.to_sentence
    }

    # 2. Cleaning logic
    # This ensures "Anterior Shoulder" stays "Anterior Shoulder"
    # and "Anterior Elbow" stays "Anterior Elbow"
    clean_raw = ->(list) { 
      Array(list).flatten.compact
                 .map { |i| i.to_s.downcase.strip }
                 .reject { |i| i == "none" || i.blank? }
                 .uniq 
    }

    p_list = clean_raw.call(paresthesia)
    s_list = clean_raw.call(sensory)
    w_list = clean_raw.call(weakness)
    r_list = clean_raw.call(reflexes)

    # 3. Paresthesia phrasing
    sections << (p_list.any? ? "paresthesia in the #{p_list.to_sentence}" : "no paresthesia")

    # 4. Sensory phrasing
    sections << (s_list.any? ? "sensory loss in the #{s_list.to_sentence}" : "intact sensation")

    # 5. Weakness phrasing
    sections << (w_list.any? ? "weakness in #{w_list.to_sentence}" : "normal motor strength")

    # 6. Reflex phrasing
    sections << (r_list.any? ? "diminished #{r_list.to_sentence} reflexes" : "no diminished reflexes")

    findings = sections.join("; ").capitalize
    "#{findings}. This presentation is suggestive of #{top_nerve} involvement. Suggest further clinical correlation."
  end
end