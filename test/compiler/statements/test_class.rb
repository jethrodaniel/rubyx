require_relative 'helper'

module Register
class TestBasicClass < MiniTest::Test
  include Statements

  def test_class_def
    @string_input = <<HERE
class Bar
  int self.buh()
    return 1
  end
end
class Object
  int main()
    return 1
  end
end
HERE
    @expect =  [Label, SaveReturn,LoadConstant,Label,RegisterTransfer,GetSlot,FunctionReturn]
    check
  end

  def test_class_call
    @string_input = <<HERE
class Bar
  int self.buh()
    return 1
  end
end
class Object
  int main()
    return Bar.buh()
  end
end
HERE
    @length = 30
    @expect =  [Label, SaveReturn,GetSlot,LoadConstant,SetSlot,LoadConstant,SetSlot,
                RegisterTransfer,FunctionCall,GetSlot,Label,RegisterTransfer,GetSlot,FunctionReturn]
    check
  end

  def test_class_field_value
    @string_input = <<HERE
class Object
  field int boo = 1
  int main()
    return 1
  end
end
HERE
    @expect =  [Label, SaveReturn,LoadConstant,Label,RegisterTransfer,GetSlot,FunctionReturn]
    assert_raises{check}
  end

  def test_class_field
    @string_input = <<HERE
class Object
  field int boo
  int main()
    return self.boo
  end
end
HERE
    @length = 17
    @expect =  [Label, SaveReturn,GetSlot,GetSlot,Label,RegisterTransfer,GetSlot,FunctionReturn]
    check
  end
end
end
