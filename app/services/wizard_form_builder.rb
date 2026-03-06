class WizardFormBuilder
  class << self
    def config
      @config ||= YAML.load_file(Rails.root.join('config', 'wizard_fields.yml'))
    end
    def groups_for(field_type, area)
      area_key = area.downcase.gsub(' ', '_')
      config.dig(field_type.to_s, area_key) || {}
    end
    def all_options_for(field_type, area)
      groups_for(field_type, area).values.flatten
    end
    def has_data_for?(field_type, area)
      area_key = area.downcase.gsub(' ', '_')
      config.dig(field_type.to_s, area_key).present?
    end
  end
end