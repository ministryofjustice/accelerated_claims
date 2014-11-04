# Helper methods for confirmation summary display
module SummaryHelper

  def summary_section_header section
    capture_haml do
      haml_tag 'div.summary-header' do
        haml_tag 'div.left', :< do
          section_header section
        end
        haml_tag 'div.right', :< do
          link_to_edit_section section
        end
      end
    end
  end

  # creates key for locale file lookup
  def localization_key section, label, suffix
    ['claim', section.sub(/_\d+/,''), label.sub(/_\d+/,''), suffix].join('.')
  end

  # creates attribute id
  def summary_id section, label
    label = adjust_summary_label(label)
    ['claim', section, label ].join('_')
  end

  def summary_label section, label
    label = adjust_summary_label label
    key = localization_key(section, label, 'label')
    if I18n.t(key)[/translation missing/]
      label.humanize
    else
      I18n.t(key).html_safe
    end
  end

  def summary_value section, label, value, values
    return nil if ignore_field?(label)
    value = adjust_summary_value(label, value, values)

    key = localization_key(section, label, value.to_s.downcase)
    localized_value = I18n.t(key)

    unless localized_value.is_a?(Hash) || localized_value[/translation missing/]
      value = localized_value.split('<span').first.html_safe
    end
    value
  end

  def link_to_edit_section section_key
    section_name = I18n.t "claim.#{section_key}.label"

    capture_haml do
      haml_tag "a", :<, href: "/##{section_key}-section" do
        haml_concat "Change #{section_name.downcase}"
      end
    end
  end

  def show_participant_address? participant, values
    first_claimant = participant['claimant_1']
    doesnt_inhabit_property = (values['inhabits_property'] == 'No')
    not_same_as_first_claimant = (values['address_same_as_first_claimant'] == 'No')
    claimant_street_different = (participant[/claimant_\d+/] &&
        (values['street'] &&
        values['street'] != @claim['claimant_1']['street']) )

    if first_claimant ||
        doesnt_inhabit_property ||
        not_same_as_first_claimant ||
        claimant_street_different
      true
    else
      false
    end
  end

  private

  def ignore_field? label
    label[/\((2|1)i\)/] || ['claimant_type',
    'num_claimants',
    'num_defendants',
    'claimant_num',
    'defendant_num',
    'validate_presence',
    'notice_served',
    'confirmed_second_rules_period_applicable_statements',
    'confirmed_first_rules_period_applicable_statements',
    'as_property',
    'address_same_as_first_claimant',
    'inhabits_property'].include?(label)
  end

  def adjust_summary_label label
    label = 'type_of_deposit' if label['as_money']

    if date_label = date_label(label)
      label = date_label
    end

    label
  end

  def adjust_summary_value label, value, values
    if date_label = date_label(label)
      value = date_value(date_label, values)
    end
    if label['as_money']
      money_deposit = (value == 'Yes')
      property_deposit = (@claim['deposit']['as_property'] == 'No')
      if money_deposit
        value = I18n.t 'claim.deposit.as_money.label'
      end
      if money_deposit && property_deposit
        value += ' and ' + I18n.t('claim.deposit.as_property.label').downcase
      elsif property_deposit
        value += I18n.t 'claim.deposit.as_property.label'
      end
    end
    value
  end

  def date_label label
    label[/(.+)\(3i\)/, 1]
  end

  def date_value label, values
    [values["#{label}(3i)"], values["#{label}(2i)"], values["#{label}(1i)"] ].join(' ')
  end
end
