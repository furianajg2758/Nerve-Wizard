class Concern < ApplicationRecord
  serialize :paresthesia, type: Array, coder: JSON
  serialize :sensory,      type: Array, coder: JSON
  serialize :weakness,     type: Array, coder: JSON
  serialize :reflexes,     type: Array, coder: JSON

def paresthesia
  super || []
end

def sensory
  super || []
end

def weakness
  super || []
end

def reflexes
  super || []
end


  # ----------------------------
  # Main matching engine
  # ----------------------------
def find_matches
  user_area = self.affected_areas.to_s.downcase.strip
  user_specific = self.specific_location.to_s.downcase.strip
  
  NerveReference.all.map do |nerve|
    report = {
      nerve: nerve,
      score: 0,
      details: { paresthesia: [], sensory: [], weakness: [], reflexes: [] }
    }

    # --- 1. HARD FILTERS ---
    actual_user_weakness = clean_list(self.weakness)
    user_definitely_has_motor_symptoms = actual_user_weakness.any?

    # Check if this nerve is sensory-only but the user has motor issues
    next nil if user_definitely_has_motor_symptoms && nerve.nerve_type == "sensory"

    # Define nerve variables for the Gate
    nerve_areas = Array(nerve.affected_areas).map { |a| a.to_s.downcase.strip }
    nerve_location = nerve.specific_location.to_s.downcase.strip

    # THE GATE: Must match primary area OR specific location
    gate_passed = nerve_areas.include?(user_area) || nerve_location == user_area || nerve_location == user_specific
    next nil unless gate_passed

    # --- 2. AREA MATCH (Dynamic Scoring) ---
    if nerve_location == user_specific && user_specific.present?
      report[:score] += 50 
    elsif nerve_areas.include?(user_area)
      report[:score] += 20 
    end

    # --- 3. SYMPTOM CATEGORY SCORES ---
    report[:score] += score_category(self.paresthesia, nerve.paresthesia, 5, report[:details][:paresthesia])
    report[:score] += score_category(self.sensory,     nerve.sensory,     5, report[:details][:sensory])
    report[:score] += score_weakness(self.weakness,    nerve.weakness,    10, report[:details][:weakness])
    report[:score] += score_category(self.reflexes,    nerve.reflexes,    15, report[:details][:reflexes])

    report
  end.compact.select { |r| r[:score] > 0 }.sort_by { |r| -r[:score] }
end

def red_flag?(top_match)
  red_flag_terms = ["saddle area", "perineum", "genitals", "bladder", "rectum"]
  user_symptoms = clean_list(self.paresthesia) + clean_list(self.sensory)
  
  has_symptom = user_symptoms.any? { |s| red_flag_terms.any? { |term| s.include?(term) } }

  is_s4 = top_match && top_match[:nerve].name.downcase.include?("s4")

  has_symptom || is_s4
end

private

def clean_list(list)
  Array(list).flatten.compact.map { |i| i.to_s.downcase.strip }.reject { |i| i.blank? || i == "none" }
end

def score_category(user_list, nerve_list, points_per_match, details_array)
  user_clean = clean_list(user_list)
  nerve_clean = clean_list(nerve_list)

  if user_clean.empty? && nerve_clean.empty?
    return 10 
  end

  matches = user_clean.select do |u|
    nerve_clean.any? { |n| n.include?(u) || u.include?(n) }
  end.uniq

  details_array.concat(matches)
  matches.size * points_per_match
end

def score_weakness(user_list, nerve_list, points_per_match, details_array)
  user_clean = clean_list(user_list)
  nerve_clean = clean_list(nerve_list)
  
  if user_clean.empty? && nerve_clean.empty?
    return 10
  end
  
  matches = user_clean.select do |u|
    nerve_clean.any? { |n| n.include?(u) || u.include?(n) }
  end.uniq
  
  details_array.concat(matches)
  
  base = matches.size * points_per_match
  return base if matches.size <= 1

  multiplier = 1.0 + (matches.size - 1) * 0.4
  (base * multiplier).round
end
end
