describe StringNormalizer do

  describe '.to_ascii' do
    let(:normalized)    { StringNormalizer.to_ascii(@orig) }

    it 'should return straight alpha characters unchanged' do
      @orig = "Tha cat sat on the mat!  Did he, really?"
      expect(normalized).to eq @orig
    end

    it 'should not change punctuation marks' do
      @orig = %q{comma, full-stops, . colons: semi-colons; "quotes", 'single quotes' / slashes  square brackets[] and angle brackets <> }
      expect(normalized).to eq @orig
    end

    it 'should not change currency marks or curly braces' do
      @orig = %q[ curly {braces} pound signs £. dollars $, euros €]
      expect(normalized).to eq @orig
    end

    it 'should not translate western European accented characters' do
      @orig = 'à á â ä æ ã å ç è é ê ë î ï í ì ñ ô ö ò ó ø õ ß û ü ù ú ÿ'
      expect(normalized).to eq @orig
    end

    it 'should not translate capitalized western European characters' do
      @orig = 'À Á Â Ä Æ Ã Å Ç È É Ê Ë Î Ï Í Ì Ñ Ô Ö Ò Ó Ø Õ SS Û Ü Ù Ú Ÿ'
      expect(normalized).to eq @orig
    end

    it 'should strip accents from exotic Eastern European Characters' do
      @orig    = 'ā ć č ē ė ę ī į ł ń ō œ ś š ū ž ź ż'
      expected = 'a c c e e e i i l n o oe s s u z z z'
      expect(normalized).to eq expected
    end

    it 'should strip accents from capitalized exotic Eastern European Characters' do
      @orig    = 'Ā Ć Č Ē Ė Ę Ī Į Ł Ń Ō Œ Ś Š Ū Ž Ź Ż'
      expected = 'A C C E E E I I L N O OE S S U Z Z Z'
      expect(normalized).to eq expected
    end

    it 'should handle a mixure of western and east European characters' do
      @orig    = 'à á â ä æ ã å ā ç ć č è é ê ë ē ė ę î ï í ī į ì ł ñ ń ô ö ò ó ø ō õ ß ś š û ü ù ú ū ÿ ž ź ż œ'
      expected = 'à á â ä æ ã å a ç c c è é ê ë e e e î ï í i i ì l ñ n ô ö ò ó ø o õ ß s s û ü ù ú u ÿ z z z oe'
      expect(normalized).to eq expected
    end

    it 'should handle Romanian characters' do
      @orig  = "ș ț ă Ș Ț Ă"
      expect(normalized).to eq "s t a S T A"
    end

    it 'should leave non-latin scripts alone' do
      @orig = 'Стивен Ричардс'
      expect(normalized).to eq @orig
    end

    it 'should handle o-macron' do
      @orig    = '23 Mōčk Stręęt Ānytōœwn Žeńśčina'
      expected = '23 Mock Street Anytooewn Zenscina'
      expect(normalized).to eq expected
    end
  end

  describe '.hash_to_ascii' do

    it 'should return the same hash with all the values normalized' do
      expect(StringNormalizer.hash_to_ascii(original_hash)).to eq expected_hash
    end
  end

  def original_hash
    {
      "name" => 'Štęfāń Rįćčardź',
      :age => 45,
      :attrs => [:a, :b, :c],
      :address => '33 Hœgh Stråt'
    }
  end

  def expected_hash
    {
      "name" => 'Stefan Riccardz',
      :age => 45,
      :attrs => [:a, :b, :c],
      :address => '33 Hoegh Stråt'
    }
  end

end