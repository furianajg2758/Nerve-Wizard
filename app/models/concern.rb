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
  # Normalize arrays consistently
  # ----------------------------
  def clean_list(list)
    Array(list)
      .map { |v| v.to_s.strip.downcase }
      .reject { |v| v.blank? || v == "none" }
  end



  # ----------------------------
  # Weakness scoring with multiplier
  # ----------------------------
  def score_weakness(user_input, nerve_ref, weight, match_list)
    user_arr = clean_list(user_input)
    db_arr   = clean_list(nerve_ref)

    matches = user_arr & db_arr
    matches.each { |m| match_list << m }

    base = matches.count * weight
    return base if matches.count <= 1

    multiplier = 1.0 + (matches.count - 1) * 0.4
    (base * multiplier).round
  end



  # ----------------------------
  # Main matching engine
  # ----------------------------
 def find_matches
    NerveReference.all.map do |nerve|
      report = {
        nerve: nerve,
        score: 0,
        details: { paresthesia: [], sensory: [], weakness: [], reflexes: [] }
      }

      # --- 1. HARD FILTER ---
      actual_user_weakness  = clean_list(self.weakness)
      user_has_motor        = actual_user_weakness.any?

      if user_has_motor && nerve.nerve_type == "sensory"
        next nil
      end

      # --- 2. AREA MATCH (Dynamic Scoring) ---
      # Check for a match on the SPECIFIC location first
      if nerve.specific_location.to_s.downcase == self.specific_location.to_s.downcase
        report[:score] += 50 # High confidence for specific sub-area
      elsif Array(nerve.affected_areas).map(&:downcase).include?(self.affected_areas.to_s.downcase)
        report[:score] += 20 # Standard broad area match
      end

      # --- 3. SYMPTOM CATEGORY SCORES ---
      report[:score] += score_category(self.paresthesia, nerve.paresthesia, 5, report[:details][:paresthesia])
      report[:score] += score_category(self.sensory,     nerve.sensory,     5, report[:details][:sensory])
      report[:score] += score_weakness(self.weakness,    nerve.weakness,    10, report[:details][:weakness])
      report[:score] += score_category(self.reflexes,    nerve.reflexes,    15, report[:details][:reflexes])

      report
    end.compact.select { |r| r[:score] > 0 }.sort_by { |r| -r[:score] }
  end



  private

  def score_category(user_input, nerve_ref, weight, match_list)
    user_arr = clean_list(user_input)
    db_arr   = clean_list(nerve_ref)

    matches = user_arr & db_arr
    matches.each { |m| match_list << m }

    matches.count * weight
  end
end
