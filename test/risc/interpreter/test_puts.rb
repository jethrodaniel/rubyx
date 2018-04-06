require_relative "helper"

module Risc
  class TestPuts < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main(" return 'Hello again'.putstring ")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [Label, LoadConstant, SlotToReg, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, SlotToReg, SlotToReg,
             SlotToReg, RegToSlot, LoadConstant, SlotToReg, RegToSlot,
             LoadConstant, SlotToReg, RegToSlot, SlotToReg, LoadConstant,
             FunctionCall, Label, SlotToReg, SlotToReg, Transfer,
             Syscall, Transfer, Transfer, LoadConstant, SlotToReg,
             SlotToReg, RegToSlot, RegToSlot, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, FunctionReturn, Transfer, Syscall, NilClass]
       assert_equal "Hello again" , @interpreter.stdout
       assert_equal Parfait::Integer , get_return.class
       assert_equal 11 , get_return.value #bytes written
    end
    def test_call
      cal =  main_ticks(26)
      assert_equal FunctionCall , cal.class
      assert_equal :putstring , cal.method.name
    end

    def test_putstring_sys
      done = main_ticks(31)
      assert_equal Syscall ,  done.class
      assert_equal "Hello again" , @interpreter.stdout
      assert_equal 11 , @interpreter.get_register(:r0)
      assert_equal Parfait::Word , @interpreter.get_register(:r1).class
      assert_equal "Hello again" , @interpreter.get_register(:r1).to_string
    end
    def test_move_sys_return
      sl = main_ticks(32)
      assert_equal Transfer , sl.class
      assert_equal :r0 , sl.from.symbol
      assert_equal :r1 , sl.to.symbol
      assert_equal 11 , @interpreter.get_register(:r1)
    end
    def test_restore_message
      sl = main_ticks(33)
      assert_equal Transfer , sl.class
      assert_equal :r8 , sl.from.symbol
      assert_equal :r0 , sl.to.symbol
      assert_equal Parfait::Message , @interpreter.get_register(:r0).class
    end
    def test_save_sys_return
      sl = main_ticks(38)
      assert_equal RegToSlot , sl.class
      assert_equal :r1 , sl.register.symbol #return
      assert_equal :r2 , sl.array.symbol #parfait integer
      assert_equal  3 , sl.index
    end
    def test_return
      done = main_ticks(45)
      assert_equal FunctionReturn ,  done.class
    end

  end
end