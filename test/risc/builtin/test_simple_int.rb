require_relative "helper"

module Risc
  module Builtin
    class SimpleInt < BuiltinTest

      def test_add
        run_all "5 + 5"
        assert_equal Parfait::Integer , get_return.class
        assert_equal 10 , get_return.value
      end
      def test_minus
        run_all "5 - 5"
        assert_equal 0 , get_return.value
      end
      def test_minus_neg
        run_all "5 - 15"
        assert_equal -10 , get_return.value
      end
      def test_div10
        run_all "45.div10"
        assert_equal 4 , get_return.value
      end
      def test_div4
        run_all "45.div4"
        assert_equal 11 , get_return.value
      end
      def test_mult
        run_all "4 * 4"
        assert_equal 16 , get_return.value
      end
      def test_smaller_true
        run_all "4 < 5"
        assert_equal Parfait::TrueClass , get_return.class
      end
      def test_smaller_false
        run_all "6 < 5"
        assert_equal Parfait::FalseClass , get_return.class
      end
      def test_larger_true
        run_all "5 > 4"
        assert_equal Parfait::TrueClass , get_return.class
      end
      def test_larger_false
        run_all "5 > 6"
        assert_equal Parfait::FalseClass , get_return.class
      end
    end
  end
end