require 'asm/arm/arm_assembler'
require 'asm/arm/instruction'
require_relative 'generator_label'
require 'asm/nodes'
require 'stream_reader'
require 'stringio'
require "asm/data_object"
    
class Asm::Arm::CodeGenerator
  def initialize
    @asm = Asm::Assembler.new
    @externs = []
  end

  def data(str)
    @asm.add_object Asm::DataObject.new(str)
  end

  %w(r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12
     r13 r14 r15 a1 a2 a3 a4 v1 v2 v3 v4 v5 v6
     rfp sl fp ip sp lr pc
  ).each { |reg|
    define_method(reg) {
      [:reg, reg]
    }
  }

  def instruction(name, *args)
    node = Asm::InstructionNode.new
    node.opcode = name.to_s
    node.args = []

    args.each { |arg|
      if (arg.is_a?(Array))
        if (arg[0] == :reg)
          node.args << Asm::RegisterNode.new(arg[1])
        end
      elsif (arg.is_a?(Integer))
        node.args << Asm::NumLiteralNode.new(arg)
      elsif (arg.is_a?(Symbol))
        node.args << Asm::LabelRefNode.new(arg.to_s)
      elsif (arg.is_a?(Asm::Arm::GeneratorLabel) or arg.is_a?(Asm::Arm::GeneratorExternLabel))
        node.args << arg
      else
        raise 'Invalid argument `%s\' for instruction' % arg.inspect
      end
    }

    @asm.add_object Asm::Arm::Instruction.new(node)
  end

  %w(adc add and bic eor orr rsb rsc sbc sub mov mvn cmn cmp teq tst b bl bx 
    push pop swi str strb ldr ldrb 
  ).each { |inst|
    define_method(inst) { |*args|
      instruction inst.to_sym, *args
    }
    define_method(inst+'s') { |*args|
      instruction (inst+'s').to_sym, *args
    }
    %w(al eq ne cs mi hi cc pl ls vc lt le ge gt vs
    ).each { |cond_suffix|
      define_method(inst+cond_suffix) { |*args|
        instruction (inst+cond_suffix).to_sym, *args
      }
      define_method(inst+'s'+cond_suffix) { |*args|
        instruction (inst+'s'+cond_suffix).to_sym, *args
      }
    }
  }

  def label
    Asm::Arm::GeneratorLabel.new(@asm)
  end

  def label!
    lbl = Asm::Arm::GeneratorLabel.new(@asm)
    lbl.set!
    lbl
  end

  def extern(sym)
    if (lbl = @externs.find { |extern| extern.name == sym })
      lbl
    else
      @externs << lbl = Asm::Arm::GeneratorExternLabel.new(sym)
      @asm.add_object lbl
      lbl
    end
  end

  def assemble
    io = StringIO.new
    @asm.assemble(io)
    io.string
  end

  def relocations
    @asm.relocations
  end
end
