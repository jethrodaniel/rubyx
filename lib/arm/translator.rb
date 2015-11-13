module Arm
  class Translator

    # translator should translate from register instructio set to it's own (arm eg)
    # for each instruction we call the translator with translate_XXX
    #  with XXX being the class name.
    # the result is replaced in the stream
    def translate  instruction
      class_name = instruction.class.name.split("::").last
      self.send( "translate_#{class_name}".to_sym , instruction)
    end

    # don't replace labels
    def translate_Label code
      nil
    end

    # Arm stores the return address in a register (not on the stack)
    # The register is called link , or lr for short .
    # Maybe because it provides the "link" back to the caller
    # the vm defines a register for the location, so we store it there.
    def translate_SaveReturn code
      ArmMachine.str( :lr ,  code.register , 4 * code.index )
    end

    def translate_GetSlot code
      # times 4 because arm works in bytes, but vm in words
      if(code.index.is_a? Numeric)
        ArmMachine.ldr( code.register ,  code.array , 4 * code.index )
      else
        ArmMachine.ldr( code.register ,  code.array , code.index )
      end
    end

    def translate_RegisterTransfer code
      # Register machine convention is from => to
      # But arm has the receiver/result as the first
      ArmMachine.mov( code.to , code.from)
    end

    def translate_SetSlot code
      # times 4 because arm works in bytes, but vm in words
      if(code.index.is_a? Numeric)
        ArmMachine.str( code.register ,  code.array , 4 * code.index )
      else
        ArmMachine.str( code.register ,  code.array , code.index )
      end
    end

    def translate_FunctionCall code
      ArmMachine.call( code.method )
    end

    def translate_FunctionReturn code
      ArmMachine.ldr( :pc ,  code.register , 4 * code.index )
    end

    def translate_LoadConstant code
      constant = code.constant
      if constant.is_a?(Parfait::Object) or constant.is_a?(Symbol) or constant.is_a?(Register::Label)
        return ArmMachine.add( code.register , constant )
      else
        return ArmMachine.mov( code.register ,  constant )
      end
    end

    def translate_OperatorInstruction code
      left = code.left
      right = code.right
      case code.operator.to_s
      when "+"
        c = ArmMachine.add(left , left , right)
      when "-"
        c = ArmMachine.sub(left , left , right)
      when "&"
        c = ArmMachine.and(left , left , right)
      when "|"
        c = ArmMachine.orr(left , left , right)
      when "*"
        c = ArmMachine.mul(left , right , left) #arm rule about left not being result, lukily commutative
      when ">>"
        c = ArmMachine.mov(left , left , :shift_asr => right) #arm rule about left not being result, lukily commutative
      when "<<"
        c = ArmMachine.mov(left , left , :shift_lsl => right) #arm rule about left not being result, lukily commutative
      else
        raise "unimplemented  '#{code.operator}' #{code}"
      end
      c
    end

    # This implements branch logic, which is simply assembler branch
    #
    # The only target for a call is a Block, so we just need to get the address for the code
    # and branch to it.
    def translate_Branch code
      ArmMachine.b( code.label )
    end

    def translate_IsPlus code
      ArmMachine.bpl( code.label)
    end

    def translate_IsMinus code
      ArmMachine.bmi( code.label)
    end

    def translate_IsZero code
      ArmMachine.beq( code.label)
    end

    def translate_IsOverflow code
      ArmMachine.bvs( code.label)
    end

    def translate_Syscall code
      call_codes = { :putstring => 4 , :exit => 1    }
      int_code = call_codes[code.name]
      raise "Not implemented syscall, #{code.name}" unless int_code
      send( code.name , int_code )
    end

    def putstring int_code
      codes = ArmMachine.ldr( :r1 , Register.message_reg, 4 * Register.resolve_index(:message , :receiver))
      codes.append ArmMachine.add( :r1 ,  :r1 , 8 )
      codes.append ArmMachine.mov( :r0 ,  1 )
      codes.append ArmMachine.mov( :r2 ,  12 ) # String length, obvious TODO
      syscall(int_code , codes )
    end

    def exit int_code
      codes = Register::Label.new(nil , "exit")
      syscall int_code , codes
    end

    private

    # syscall is always triggered by swi(0)
    # The actual code (ie the index of the kernel function) is in r7
    def syscall int_code , codes
      codes.append ArmMachine.mov( :r7 ,  int_code )
      codes.append ArmMachine.swi( 0 )
      codes
    end

  end
end
