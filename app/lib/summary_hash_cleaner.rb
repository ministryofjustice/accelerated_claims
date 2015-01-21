class SummaryHashCleaner

  @@keys_to_be_cleaned = ['manually_entered_address']

  def initialize(hash)
    @hash = hash
  end

  def clean
    remove_attrs(@hash)
  end

  private

  def remove_attrs(hash)
    hash.each do |key, value|
      if value.is_a?(Hash)
        value = remove_attrs(value)
      else
        hash.delete_if{ |key, _| @@keys_to_be_cleaned.include?(key) }
      end
    end
  end
end