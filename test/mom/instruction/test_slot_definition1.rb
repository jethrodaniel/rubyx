require_relative "helper"

module Mom

  class TestSlotDefinitionConstant < MiniTest::Test
    def setup
      Risc.machine.boot
      @compiler = CompilerMock.new
      @definition = SlotDefinition.new(StringConstant.new("hi") , [])
      @instruction = @definition.to_register(@compiler , InstructionMock.new)
    end
    def test_def_class
      assert_equal Risc::LoadConstant , @instruction.class
    end
    def test_def_register
      assert_equal :r1 , @instruction.register.symbol
    end
    def test_def_const
      assert_equal "hi" , @instruction.constant.to_string
    end
  end
end