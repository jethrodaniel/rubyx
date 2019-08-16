require_relative "helper"

module Vool
  class TestSimpleWhileMom < MiniTest::Test
    include VoolCompile

    def setup
      Parfait.boot!(Parfait.default_test_options)
      @compiler = compile_first_method( "while(@a) ; @a = 5 ; end")
      @ins = @compiler.mom_instructions.next
    end

    def test_compiles_as_while
      assert_equal Label , @ins.class , @ins
    end
    def test_condition_compiles_to_check
      assert_equal TruthCheck , @ins.next.class , @ins
    end
    def test_condition_is_slot
      assert_equal SlotDefinition , @ins.next.condition.class , @ins
    end
    def test_array
      check_array [Label, TruthCheck, SlotLoad, Jump, Label ,
                    Label, ReturnSequence, Label], @ins
    end
  end
end