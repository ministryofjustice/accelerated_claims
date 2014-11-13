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
      @orig    = 'ā ć č ē ė ę ī į ł ń œ ś š ū ž ź ż'
      expected = 'a c c e e e i i l n oe s s u z z z'
      expect(normalized).to eq expected
    end

    it 'should strip accents from capitalized exotic Eastern European Characters' do
      @orig    = 'Ā Ć Č Ē Ė Ę Ī Į Ł Ń Œ Ś Š Ū Ž Ź Ż'
      expected = 'A C C E E E I I L N OE S S U Z Z Z'
      expect(normalized).to eq expected
    end

    it 'should leave non-latin scripts alone' do
      @orig = 'Стивен Ричардс'
      expect(normalized).to eq @orig
    end



  end

end