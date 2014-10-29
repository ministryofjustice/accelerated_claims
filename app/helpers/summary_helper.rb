# Helper methods for confirmation summary display
module SummaryHelper

  # creates key for locale file lookup
  def localization_key section, label, suffix
    ['claim', section.sub(/_\d+/,''), label.sub(/_\d+/,''), suffix].join('.')
  end

  # creates attribute id
  def summary_id section, label
    ['claim', section, label].join('_')
  end

  def summary_label section, label
    key = localization_key(section, label, 'label')
    if I18n.t(key)[/translation missing/]
      label.humanize
    else
      I18n.t(key).html_safe
    end
  end

  def summary_value section, label, value
    key = localization_key(section, label, value.to_s.downcase)
    localized_value = I18n.t(key)

    unless localized_value.is_a?(Hash) || localized_value[/translation missing/]
      value = localized_value.split('<span').first.html_safe
    end
    value
  end

end
