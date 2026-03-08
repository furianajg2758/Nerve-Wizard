class WizardController < ApplicationController
  include Wicked::Wizard

  layout 'wizard'

  before_action :load_concern
  before_action :set_steps
  before_action :setup_wizard

  def restart
    session[:concern_id] = nil
    session[:diagnostic_id] = nil
    @concern = Concern.create!
    session[:concern_id] = @concern.id
    redirect_to wizard_path(:choose_areas)
  end

  def sources
  end

  def show
    @concern = Concern.find(session[:concern_id])
    @type = step.to_sym 

    if @type == :refine_area
      set_sub_regions
      @display_title = "#{@concern.affected_areas&.titleize}: Specific Location"
      @display_blurb = "Please narrow down exactly where you are feeling the symptoms."
    end

    if [:paresthesia, :sensory, :weakness, :reflexes].include?(@type)
      location_slug = (@concern.specific_location.presence || @concern.affected_areas)
                       &.downcase&.strip&.gsub(' ', '_')
      
      location_name = (@concern.specific_location.presence || @concern.affected_areas)&.titleize
      
      @metadata = step_metadata_for(@type)
      @display_title = "#{location_name}: #{@metadata[:title]}"
      @display_blurb = @metadata[:blurb]
      
      @current_options = symptom_options_for(location_slug, @type)

      render "shared_symptoms_template" and return
    end

    if @type == :results
      @matches = @concern.find_matches || []
    end

    render_wizard
  end

  def update
    if @concern.update(concern_params)
      render_wizard @concern
    else
      render_wizard @concern
    end
  end

  private

  def load_concern
    if session[:concern_id].present?
      @concern = Concern.find(session[:concern_id])
    else
      @concern = Concern.create!
      session[:concern_id] = @concern.id
    end

    %i[paresthesia sensory weakness reflexes].each do |field|
      @concern[field] ||= []
    end
  end

  def set_sub_regions
    region_map = {
      "head" => ["Head", "Face"],
      "neck" => ["Neck"],
      "shoulder" => ["Anterior Shoulder", "Posterior Shoulder", "Lateral Shoulder"],
      "upper arm" => ["Anterior Upper Arm", "Posterior Upper Arm", "Lateral Upper Arm", "Medial Upper Arm"],
      "elbow" => ["Anterior Elbow", "Posterior Elbow", "Lateral Elbow", "Medial Elbow"],
      "forearm" => ["Anterior Forearm", "Posterior Forearm", "Lateral Forearm", "Medial Forearm"],
      "wrist" => ["Anterior Wrist", "Posterior Wrist", "Lateral Wrist", "Medial Wrist"],
      "hand" => ["Dorsum of Hand", "Radial Hand", "Medial Hand"],
      "torso" => ["Torso"],
      "thigh" => ["Anterior Thigh", "Posterior Thigh", "Lateral Thigh", "Distal Medial Thigh", "Proximal Medial Thigh"],
      "knee" => ["Anterior Knee", "Posterior Knee", "Lateral Knee", "Medial Knee"],
      "lower leg" => ["Anterior Lower Leg", "Posterior Lower Leg", "Lateral Lower Leg", "Medial Lower Leg"],
      "ankle" => ["Anterior Ankle", "Posterior Ankle", "Lateral Ankle", "Medial Ankle"],
      "foot" => ["Dorsum of Foot", "Heel", "Lateral Sole of Foot", "Medial Sole of Foot"]
    }

    main_area = @concern.affected_areas&.downcase&.strip
    @sub_regions = region_map[main_area] || []
  end

  def set_steps
    self.steps = [:choose_areas, :refine_area, :paresthesia, :sensory, :weakness, :reflexes, :results]
  end

  def symptom_options_for(location, type)
    maps = {
      paresthesia: {
        "head" => ["vertex of skull", "posterior head", "side of head", "forehead", "temple", "nose", "cheek", "ear", "upper lip", "mandible", "side of neck"],
        "neck" => ["cheek", "posterior neck", "side of neck", "clavicular area"],
        "anterior_shoulder" => ["anterior shoulder", "posterior shoulder", "lateral shoulder", "medial upper arm", "medial elbow", "medial forearm"],
        "posterior_shoulder" => ["anterior shoulder", "posterior shoulder", "lateral shoulder"],
        "lateral_shoulder" => ["anterior shoulder", "posterior shoulder", "lateral shoulder"],
        "anterior_upper_arm" => ["thumb", "index finger"],
        "posterior_upper_arm" => ["posterior upper arm", "index finger", "middle finger", "ring finger"],
        "lateral_upper_arm" => ["lateral upper arm", "lateral elbow", "index finger", "middle finger", "ring finger"],
        "medial_upper_arm" => ["anterior shoulder", "medial upper arm", "medial elbow", "medial forearm", "little finger"],
        "anterior_elbow" => [],
        "posterior_elbow" => ["posterior elbow", "posterior forearm", "posterior wrist", "index finger", "middle finger", "ring finger"],
        "lateral_elbow" => ["lateral upper arm", "lateral elbow", "anterior forearm", "lateral forearm", "lateral wrist", "index finger", "middle finger", "ring finger"],
        "medial_elbow" => ["medial elbow", "anterior forearm", "medial forearm", "thumb", "index finger", "little finger"],
        "anterior_forearm" => ["lateral elbow", "medial elbow", "anterior forearm", "lateral forearm", "medial forearm", "lateral wrist"],
        "posterior_forearm" => ["posterior elbow", "posterior forearm", "posterior wrist"],
        "lateral_forearm" => ["lateral elbow", "anterior forearm", "lateral forearm", "lateral wrist", "thumb", "index finger", "middle finger", "ring finger"],
        "medial_forearm" => ["little finger"],
        "anterior_wrist" => ["index finger", "middle finger", "ring finger"],
        "posterior_wrist" => ["posterior elbow", "posterior forearm", "posterior wrist"],
        "lateral_wrist" => ["lateral elbow", "anterior forearm", "lateral forearm", "lateral wrist", "thumb", "index finger"],
        "medial_wrist" => ["medial wrist", "medial hand", "ring finger", "little finger"],
        "dorsum_of_hand" => ["dorsum of hand", "thumb", "index finger", "middle finger"],
        "radial_hand" => ["radial hand", "thumb", "index finger", "middle finger", "ring finger"],
        "medial_hand" => ["little finger"],
        "torso" => ["side of neck", "clavicular area", "horizontal band along clavicle and upper scapula", "groin", "saddle area"],
        "hip" => ["groin", "anterior hip", "lateral hip"],
        "anterior_thigh" => ["anterior thigh", "anterior knee", "medial knee", "anterior lower leg"],
        "posterior_thigh" => ["posterior thigh", "posterior knee", "lateral knee", "posterior lower leg", "lateral lower leg", "lateral ankle", "lateral foot", "heel", "big toe", "second toe", "third toe"],
        "lateral_thigh" => ["lateral thigh", "medial lower leg", "medial ankle"],
        "distal_medial_thigh" => ["distal medial thigh"],
        "proximal_medial_thigh" => ["proximal medial thigh"],
        "anterior_knee" => ["anterior thigh", "anterior knee", "anterior lower leg"],
        "posterior_knee" => ["posterior thigh", "posterior knee", "posterior lower leg"],
        "lateral_knee" => ["lateral knee", "lateral lower leg", "lateral ankle", "lateral foot", "big toe", "second toe", "third toe"],
        "medial_knee" => ["medial knee", "medial lower leg", "medial ankle", "medial arch of foot"],
        "anterior_lower_leg" => ["anterior thigh", "anterior knee", "anterior lower leg"],
        "posterior_lower_leg" => ["posterior thigh", "posterior knee", "posterior lower leg", "lateral lower leg", "medial lower leg", "dorsum of foot", "lateral sole of foot", "medial sole of foot"],
        "lateral_lower_leg" => ["posterior lower leg", "lateral lower leg", "medial lower leg", "lateral ankle", "dorsum of foot", "lateral foot", "heel", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two", "big toe", "second toe", "third toe", "fourth toe", "fifth toe"],
        "medial_lower_leg" => ["medial knee", "posterior lower leg", "lateral lower leg", "medial lower leg", "medial ankle", "dorsum of foot", "lateral sole of foot", "medial sole of foot", "medial arch of foot"],
        "anterior_ankle" => [],
        "posterior_ankle" => ["lateral lower leg", "lateral ankle", "lateral foot", "lateral sole of foot", "medial sole of foot", "fourth toe", "fifth toe"],
        "lateral_ankle" => ["lateral lower leg", "lateral ankle", "dorsum of foot", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two"],
        "medial_ankle" => ["medial lower leg", "medial ankle"],
        "dorsum_of_foot" => ["lateral lower leg", "lateral ankle", "dorsum of foot", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two"],
        "heel" => ["heel"],
        "lateral_sole_of_foot" => ["lateral lower leg", "lateral ankle", "dorsum of foot", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two"],
        "medial_sole_of_foot" => ["lateral lower leg", "lateral ankle", "dorsum of foot", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two"]
      },
      sensory: {
        "head" => ["vertex of skull", "posterior head", "side of head", "temple", "forehead", "cheek", "nose", "ear", "occiput", "upper lip", "mandible", "anterior neck", "posterior neck", "side of neck"],
        "neck" => ["posterior cheek", "temple", "mandible", "anterior neck", "posterior neck", "side of neck"],
        "anterior_shoulder" => ["anterior shoulder", "posterior shoulder", "lateral shoulder", "anterior upper arm", "medial upper arm", "anterior elbow", "medial elbow", "anterior forearm", "medial forearm"],
        "posterior_shoulder" => ["anterior shoulder", "posterior shoulder", "lateral shoulder", "anterior elbow", "anterior upper arm", "anterior forearm"],
        "lateral_shoulder" => ["anterior shoulder", "posterior shoulder", "lateral shoulder", "anterior elbow", "anterior upper arm", "anterior forearm"],
        "anterior_upper_arm" => ["anterior shoulder", "posterior shoulder", "lateral shoulder", "anterior upper arm", "anterior elbow", "medial elbow", "anterior forearm", "lateral forearm", "lateral wrist", "radial hand", "thumb", "index finger"],
        "posterior_upper_arm" => ["posterior upper arm", "lateral upper arm", "posterior elbow", "lateral elbow", "lateral forearm", "anterior wrist", "radial hand", "index finger", "middle finger", "ring finger"],
        "lateral_upper_arm" => ["posterior upper arm", "lateral upper arm", "posterior elbow", "lateral elbow", "lateral forearm", "anterior wrist", "radial hand", "index finger", "middle finger", "ring finger"],
        "medial_upper_arm" => ["pectoral area", "midscapular area", "medial upper arm", "medial elbow", "medial forearm", "medial wrist", "medial hand", "middle finger", "ring finger", "little finger"],
        "anterior_elbow" => [],
        "posterior_elbow" => ["posterior upper arm", "lateral upper arm", "posterior elbow", "lateral elbow", "posterior forearm", "lateral forearm", "anterior wrist", "posterior wrist", "radial hand", "index finger", "middle finger", "ring finger"],
        "lateral_elbow" => ["posterior upper arm", "lateral upper arm", "posterior elbow", "lateral elbow", "anterior forearm", "lateral forearm", "anterior wrist", "lateral wrist", "radial hand", "index finger", "middle finger", "ring finger"],
        "medial_elbow" => ["pectoral area", "midscapular area", "anterior upper arm", "medial upper arm", "medial elbow", "anterior forearm", "lateral forearm", "medial forearm", "lateral wrist", "medial wrist", "radial hand", "medial hand", "thumb", "index finger", "middle finger", "ring finger"],
        "anterior_forearm" => ["anterior shoulder", "posterior shoulder", "lateral shoulder", "anterior upper arm", "anterior elbow", "lateral elbow", "anterior forearm", "lateral wrist"],
        "posterior_forearm" => ["posterior elbow", "posterior forearm", "posterior wrist"],
        "lateral_forearm" => ["anterior upper arm", "posterior upper arm", "lateral upper arm", "posterior elbow", "lateral elbow", "medial elbow", "lateral forearm", "anterior wrist", "lateral wrist", "radial hand", "thumb", "index finger"],
        "medial_forearm" => ["medial elbow", "anterior forearm", "medial forearm", "medial hand"],
        "anterior_wrist" => [],
        "posterior_wrist" => ["posterior elbow", "posterior forearm", "posterior wrist"],
        "lateral_wrist" => ["anterior upper arm", "lateral elbow", "medial elbow", "anterior forearm", "lateral forearm", "lateral wrist", "radial hand", "thumb", "index finger"],
        "medial_wrist" => ["medial elbow", "medial forearm", "medial wrist", "medial hand", "ring finger", "little finger"],
        "dorsum_of_hand" => ["dorsum of hand", "thumb", "index finger", "middle finger"],
        "radial_hand" => ["anterior upper arm", "posterior upper arm", "lateral upper arm", "posterior elbow", "lateral elbow", "medial elbow", "lateral forearm", "anterior wrist", "lateral wrist", "radial hand", "thumb", "index finger", "middle finger", "ring finger"],
        "medial_hand" => ["medial wrist", "medial hand", "ring finger", "little finger"],
        "torso" => ["side of neck", "clavicular area", "groin", "perineum", "genitals", "lower sacrum", "clavicular area", "upper thorax", "pectoral area", "costal margin", "abdomen", "low back", "upper scapular area", "midscapular area", "medial upper arm", "medial elbow", "greater trochanter"],
        "hip" => ["low back", "groin", "greater trochanter", "anterior hip", "lateral hip"],
        "anterior_thigh" => ["back", "buttock", "anterior thigh", "anterior knee", "anterior lower leg", "medial lower leg"],
        "posterior_thigh" => ["buttock", "posterior thigh", "lateral thigh", "posterior knee", "lateral knee", "posterior lower leg", "lateral lower leg", "posterior ankle", "dorsum of foot", "medial sole of foot", "big toe", "second toe", "third toe"],
        "lateral_thigh" => ["buttock", "posterior thigh", "lateral thigh", "lateral lower leg", "medial lower leg", "medial ankle", "dorsum of foot", "medial sole of foot", "big toe", "second toe", "third toe"],
        "distal_medial_thigh" => ["groin", "distal medial thigh"],
        "proximal_medial_thigh" => ["groin", "proximal medial thigh"],
        "anterior_knee" => ["back", "buttock", "anterior thigh", "anterior knee", "anterior lower leg", "medial lower leg"],
        "posterior_knee" => ["buttock", "posterior thigh", "posterior knee", "posterior lower leg", "posterior ankle"],
        "lateral_knee" => ["buttock", "posterior thigh", "lateral thigh", "lateral knee", "lateral lower leg", "dorsum of foot", "medial sole of foot", "big toe", "second toe", "third toe"],
        "medial_knee" => ["distal medial thigh", "medial knee", "medial lower leg", "medial ankle", "medial arch of foot"],
        "anterior_lower_leg" => ["anterior thigh", "anterior knee", "anterior lower leg"],
        "posterior_lower_leg" => ["posterior thigh", "posterior knee", "posterior lower leg", "lateral lower leg", "medial lower leg", "dorsum of foot", "lateral sole of foot", "medial sole of foot"],
        "lateral_lower_leg" => ["buttock", "posterior thigh", "lateral thigh", "lateral knee", "posterior lower leg", "lateral lower leg", "medial ankle", "lateral ankle", "dorsum of foot", "lateral foot", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two", "big toe", "second toe", "third toe", "fifth toe"],
        "medial_lower_leg" => ["back", "buttock", "anterior thigh", "lateral thigh", "anterior knee", "medial knee", "posterior lower leg", "lateral lower leg", "medial lower leg", "medial ankle", "dorsum of foot", "lateral sole of foot", "medial sole of foot", "medial arch of foot", "big toe"],
        "anterior_ankle" => [],
        "posterior_ankle" => ["buttock", "posterior thigh", "posterior knee", "posterior lower leg", "posterior ankle"],
        "lateral_ankle" => ["lateral lower leg", "lateral ankle", "dorsum of foot", "lateral foot", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two", "fifth toe"],
        "medial_ankle" => ["buttock", "lateral thigh", "medial lower leg", "medial ankle", "dorsum of foot", "big toe"],
        "dorsum_of_foot" => ["buttock", "posterior thigh", "lateral thigh", "lateral knee", "posterior lower leg", "lateral lower leg", "medial lower leg", "lateral ankle", "medial ankle", "dorsum of foot", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two", "big toe", "second toe", "third toe"],
        "heel" => ["heel"],
        "lateral_sole_of_foot" => ["posterior lower leg", "lateral lower leg", "medial lower leg", "lateral ankle", "dorsum of foot", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two"],
        "medial_sole_of_foot" => ["posterior lower leg", "lateral lower leg", "medial lower leg", "lateral ankle", "dorsum of foot", "lateral sole of foot", "medial sole of foot", "webbing between toes one and two"]
      },
      weakness: {
        "head" => ["neck flexors", "neck side flexors"],
        "neck" => ["neck side flexors"],
        "anterior_shoulder" => ["shoulder abductors", "shoulder lateral rotators"],
        "posterior_shoulder" => ["shoulder abductors", "shoulder lateral rotators"],
        "lateral_shoulder" => ["shoulder abductors", "shoulder lateral rotators"],
        "anterior_upper_arm" => ["shoulder abductors", "shoulder lateral rotators", "elbow flexors", "forearm supinators", "wrist extensors"],
        "posterior_upper_arm" => ["elbow extensors", "wrist flexors"],
        "lateral_upper_arm" => ["elbow extensors", "wrist flexors"],
        "medial_upper_arm" => ["wrist ulnar deviators", "thumb extensors", "thumb adductors"],
        "anterior_elbow" => ["shoulder abductors", "shoulder lateral rotators"],
        "posterior_elbow" => ["elbow extensors", "wrist flexors"],
        "lateral_elbow" => ["elbow extensors", "wrist flexors"],
        "medial_elbow" => ["elbow flexors", "forearm supinators", "wrist extensors", "wrist ulnar deviators", "thumb extensors", "thumb adductors"],
        "anterior_forearm" => ["shoulder abductors", "shoulder lateral rotators"],
        "posterior_forearm" => [],
        "lateral_forearm" => ["elbow flexors", "elbow extensors", "forearm supinators", "wrist flexors", "wrist extensors"],
        "medial_forearm" => ["wrist ulnar deviators", "thumb extensors", "thumb adductors"],
        "anterior_wrist" => ["elbow extensors", "wrist flexors"],
        "posterior_wrist" => [],
        "lateral_wrist" => ["elbow flexors", "forearm supinators", "wrist extensors"],
        "medial_wrist" => ["wrist flexors", "wrist ulnar deviators", "thumb extensors", "thumb adductors"],
        "dorsum_of_hand" => ["elbow extensors", "forearm supinators", "wrist extensors", "thumb abductors", "finger abductors", "finger adductors"],
        "radial_hand" => ["elbow flexors", "elbow extensors", "forearm pronators", "forearm supinators", "wrist flexors", "wrist extensors", "wrist radial deviators", "thumb adductors"],
        "medial_hand" => ["wrist ulnar deviators", "thumb extensors", "thumb adductors"],
        "torso" => ["shoulder elevators", "bladder", "rectum"],
        "hip" => [], # FIXED: Added comma
        "anterior_thigh" => ["hip flexors", "hip adductors", "knee extensors"],
        "posterior_thigh" => ["hip abductors", "knee flexors", "ankle plantarflexors", "ankle dorsiflexors", "ankle everters", "big toe extensors"],
        "lateral_thigh" => ["hip abductors", "ankle dorsiflexors", "ankle everters", "big toe extensors"],
        "distal_medial_thigh" => [],
        "proximal_medial_thigh" => ["hip adductors"],
        "anterior_knee" => ["hip flexors", "knee extensors"],
        "posterior_knee" => [],
        "lateral_knee" => ["hip abductors", "ankle dorsiflexors", "ankle everters", "big toe extensors"],
        "medial_knee" => [],
        "anterior_lower_leg" => ["hip flexors", "knee extensors"],
        "posterior_lower_leg" => ["knee flexors", "ankle dorsiflexors", "ankle plantarflexors", "ankle everters", "ankle inverters"],
        "lateral_lower_leg" => ["hip abductors", "hip extensors", "knee flexors", "ankle dorsiflexors", "ankle plantarflexors", "ankle everters", "ankle inverters", "big toe extensors"],
        "medial_lower_leg" => ["hip flexors", "knee flexors", "knee extensors", "ankle dorsiflexors", "ankle plantarflexors", "ankle everters", "ankle inverters", "big toe extensors"],
        "anterior_ankle" => [],
        "posterior_ankle" => ["knee flexors", "ankle plantarflexors"],
        "lateral_ankle" => ["ankle dorsiflexors", "ankle everters"],
        "medial_ankle" => ["ankle dorsiflexors", "big toe extensors"],
        "dorsum_of_foot" => ["hip abductors", "knee flexors", "ankle dorsiflexors", "ankle plantarflexors", "ankle everters", "ankle inverters", "big toe extensors"],
        "heel" => ["ankle plantarflexors"],
        "lateral_sole_of_foot" => ["knee flexors", "ankle dorsiflexors", "ankle plantarflexors", "ankle everters", "ankle inverters", "intrinsic foot muscles"],
        "medial_sole_of_foot" => ["knee flexors", "ankle dorsiflexors", "ankle plantarflexors", "ankle everters", "ankle inverters", "intrinsic foot muscles"]
      },
      reflexes: {
        "head" => [],    # FIXED: Added comma
        "neck" => [],    # FIXED: Added comma
        "anterior_shoulder" => ["biceps brachii", "brachioradialis"],
        "posterior_shoulder" => ["biceps brachii", "brachioradialis"],
        "lateral_shoulder" => ["biceps brachii", "brachioradialis"],
        "anterior_upper_arm" => ["biceps brachii", "brachioradialis"],
        "posterior_upper_arm" => ["triceps"],
        "lateral_upper_arm" => ["triceps"],
        "medial_upper_arm" => ["triceps"],
        "anterior_elbow" => ["biceps brachii", "brachioradialis"],
        "posterior_elbow" => ["triceps"],
        "lateral_elbow" => ["triceps"],
        "medial_elbow" => ["biceps brachii", "brachioradialis", "triceps"],
        "anterior_forearm" => ["biceps brachii", "brachioradialis"],
        "posterior_forearm" => [],
        "lateral_forearm" => ["biceps brachii", "brachioradialis", "triceps"],
        "medial_forearm" => ["triceps"],
        "anterior_wrist" => ["triceps"],
        "posterior_wrist" => [],
        "lateral_wrist" => ["biceps brachii", "brachioradialis"],
        "medial_wrist" => ["triceps"],
        "dorsum_of_hand" => [],
        "radial_hand" => ["biceps brachii", "brachioradialis", "triceps"],
        "medial_hand" => ["triceps"],
        "torso" => [],
        "hip" => [],
        "anterior_thigh" => ["patellar"],
        "posterior_thigh" => ["Achilles"],
        "lateral_thigh" => [],
        "distal_medial_thigh" => [],
        "proximal_medial_thigh" => [],
        "anterior_knee" => ["patellar"],
        "posterior_knee" => ["Achilles"],
        "lateral_knee" => [],
        "medial_knee" => [],
        "anterior_lower_leg" => ["patellar"],
        "posterior_lower_leg" => ["Achilles"],
        "lateral_lower_leg" => ["Achilles"],
        "medial_lower_leg" => ["patellar", "Achilles"],
        "anterior_ankle" => [],
        "posterior_ankle" => ["Achilles"],
        "lateral_ankle" => [],
        "medial_ankle" => [],
        "dorsum_of_foot" => ["Achilles"],
        "heel" => [],
        "lateral_sole_of_foot" => ["Achilles"],
        "medial_sole_of_foot" => ["Achilles"]
      }
    }
    maps[type][location] || ["General discomfort in this area"]
  end

  def step_metadata_for(type)
    {
      paresthesia: {
        title: "Paresthesia",
        blurb: "Select areas with tingling, pins-and-needles, or crawling sensations."
      },
      sensory: {
        title: "Sensory Loss",
        blurb: "Select areas with partial or total sensory loss."
      },
      weakness: {
        title: "Muscle Weakness",
        blurb: "Select muscle groups with weakness (less than grade 5)."
      },
      reflexes: {
        title: "Affected Reflexes",
        blurb: "Select any affected reflexes."
      }
    }[type] || { title: type.to_s.humanize, blurb: "" }
  end

  def concern_params
    p = params.require(:concern).permit(
      :affected_areas,
      :specific_location,
      paresthesia: [],
      sensory: [],
      weakness: [],
      reflexes: []
    )

    %i[paresthesia sensory weakness reflexes].each do |field|
      p[field] = Array(p[field]) if p.key?(field)
    end
    p
  end
end