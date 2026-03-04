class WizardController < ApplicationController
  include Wicked::Wizard

  layout 'wizard'

  before_action :load_concern
  before_action :set_steps
  before_action :setup_wizard

def restart
  session[:concern_id] = nil
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
  @concern = Concern.find(session[:concern_id])
  puts @concern.inspect

  if step.to_s == "results"
    @matches = @concern.find_matches
  end

  render_wizard
end

def update
  @concern = Concern.find(session[:concern_id])
  if @concern.update(concern_params)
    set_steps # Recalculate steps based on the NEW saved area
    redirect_to wizard_path(next_step)
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

def set_steps
  area = @concern&.affected_areas
  
  if area.present?
    # .downcase ensures "Wrist" becomes "wrist"
    # .strip removes any accidental hidden spaces
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
end
