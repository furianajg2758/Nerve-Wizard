class WizardController < ApplicationController
  include Wicked::Wizard

  layout 'wizard'

  before_action :load_concern
  before_action :set_steps
  before_action :setup_wizard

  def restart
    session[:concern_id] = nil
    session[:diagnostic_id] = nil  # Clear this too if it exists
    @concern = Concern.create!
    session[:concern_id] = @concern.id
    redirect_to wizard_path(:choose_areas)
  end

  def start
    @concern = Concern.create!
    session[:concern_id] = @concern.id
    redirect_to wizard_path(:choose_areas)
  end

  def show    

    if step.to_s == "results"
      @matches = @concern.find_matches
    end
    
    render_wizard
  end

def update
  if @concern.update(concern_params)
    if step == :choose_areas
      # After choosing an area, recalculate steps and go to the FIRST real step
      set_steps
      redirect_to wizard_path(steps[1]) # Go to paresthesia step directly
    else
      redirect_to wizard_path(next_step)
    end
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

    # Initialize arrays
    %i[paresthesia sensory weakness reflexes].each do |field|
      @concern[field] ||= []
    end
  end

def set_steps
  area = @concern&.affected_areas
  
  if area.present?
    clean_area = area.downcase.strip.gsub(' ', '_')
    
    self.steps = [
      :choose_areas,
      "#{clean_area}_paresthesia".to_sym,
      "#{clean_area}_sensory".to_sym,
      "#{clean_area}_weakness".to_sym,
      "#{clean_area}_reflexes".to_sym,
      :results
    ]
  else
    # Just the first step when no area is selected
    self.steps = [:choose_areas]
  end
end


  def concern_params
    p = params.require(:concern).permit(
      :affected_areas,
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
  
  # Remove current_diagnostic method - it's not needed
end
