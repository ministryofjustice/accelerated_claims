

class SuperClass


  def meth(param)
    puts "In meth in superclass"
    puts param
  end

end


class ChildClass < SuperClass

  def meth
    super('xxxx')
  end
end



ChildClass.new.meth