class StringNormalizer

  @@accented = "ĀāĂăĄąĆćČčĒēĖėĘęĚěĞğĢģİıĪīĮįĶķŁłĽľĻļŅņŃńŇňŐőŌōŘřŞşŚśŠšȘșŠšȚțŤťŪūŮůŰűÝýŽžŹźŻżŽž"
  @@normal   = "AaAaAaCcCcEeEeEeEeGgGgIiIiIiKkLlLlLlNnNnNnOoOoRrSSSsSsSsSsTtTtUuUuUuYyZzZzZzZz"

  def self.to_ascii(string)
    string.tr(@@accented, @@normal).gsub('Œ', 'OE').gsub('œ', 'oe')
  end

  def self.hash_to_ascii(hash)
    hash.each do |k, v|
      hash[k] = StringNormalizer.to_ascii(v) if v.is_a?(String)
    end
    hash
  end

end

