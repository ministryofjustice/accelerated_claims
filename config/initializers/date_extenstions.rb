
class Date
  
  def long_monthname
    self.strftime('%B')
  end

  def short_monthname
    self.strftime('%b')
  end

end