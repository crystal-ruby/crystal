require_relative 'helper'

module Register
class TestClassStatements #< MiniTest::Test
  include Statements

  def test_class_defs
    @input = <<HERE
class Bar
  int self.buh()
    return 1
  end
end
class Space
  int main()
    return 1
  end
end
HERE
    @expect =  [Label, LoadConstant,SetSlot,Label,FunctionReturn]
    check
  end

  def test_class_call
    @input = <<HERE
class Bar
  int self.buh()
    return 1
  end
end
class Space
  int main()
    return Bar.buh()
  end
end
HERE
    @expect = [Label, GetSlot, LoadConstant, SetSlot, LoadConstant, SetSlot, LoadConstant ,
               SetSlot, LoadConstant, SetSlot, RegisterTransfer, FunctionCall, Label, RegisterTransfer ,
               GetSlot, GetSlot, SetSlot, Label, FunctionReturn]
    check
  end

  def test_class_field
    @input = <<HERE
class Space
  field int boo2
  int main()
    return self.boo2
  end
end
HERE
    @expect =  [Label, GetSlot,GetSlot,SetSlot,Label,FunctionReturn]
    check
  end
end
end