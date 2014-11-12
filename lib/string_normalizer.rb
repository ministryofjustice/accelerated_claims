class StringNormalizer

  @@accented = "ĀāĆćČčĒēĖėĘęĪīĮįŁłŃńŚśŠšŪūŽžŹźŻż"
  @@normal   = "AaCcCcEeEeEeIiIiLlNnSsSsUuZzZzZz"

  def self.to_ascii(string)
    string.tr(@@accented, @@normal).gsub('Œ', 'OE').gsub('œ', 'oe')
  end

end

