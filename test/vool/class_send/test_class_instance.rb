require_relative "helper"

module Vool
  class TestClassInstance < MiniTest::Test
    include Mom
    include VoolCompile

    def class_main
      <<-eos
        class Space
          def self.some_inst
            return @inst
          end
          def main(arg)
            return Space.some_inst
          end
        end
      eos
    end

    def setup
      ret = RubyX::RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(class_main)
      @compiler = ret.compilers.find{|c|c.callable.name==:some_inst}
      @main = ret.compilers.find{|c|c.callable.name==:main}
      @ins = @compiler.mom_instructions.next
    end
    def test_class_inst
      space_class = Parfait.object_space.get_class
      assert_equal :Space , space_class.name
      names = space_class.singleton_class.instance_type.names
      assert names.index_of(:inst) , names
    end
    def test_compiler
      assert_equal Mom::MethodCompiler, @compiler.class
      assert_equal Parfait::Type, @compiler.callable.self_type.class
      assert_equal 6, @compiler.callable.self_type.names.index_of(:inst) , @compiler.callable.self_type.names
    end
    def test_array
      check_array [SlotLoad, ReturnJump, Label, ReturnSequence, Label]  , @ins
    end
    def test_main_array
      check_array [MessageSetup, ArgumentTransfer, SimpleCall, SlotLoad, ReturnJump ,
                    Label, ReturnSequence, Label]  , @main.mom_instructions.next
    end
    def test_main_args
      args = @main.mom_instructions.next(2)
      assert_equal Parfait::Class , args.receiver.known_object.class
      assert_equal :Space , args.receiver.known_object.name
      assert_equal :some_inst , args.receiver.known_object.type.method_names.first
      assert_equal :inst , args.receiver.known_object.type.names.last
    end
    def test_load_inst
      assert_equal SlotLoad,  @ins.class
    end
    def test_left
      assert_equal SlotDefinition , @ins.left.class
      assert_equal [:return_value] , @ins.left.slots
    end
    def test_right
      assert_equal SlotDefinition , @ins.right.class
      assert_equal [:receiver , :inst] , @ins.right.slots
    end
  end
end