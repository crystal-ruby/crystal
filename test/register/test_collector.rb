require_relative "../helper"

module Register
  class TestCollector < MiniTest::Test
    def test_simple_collect
      Machine.new.boot
      objects = Register::Collector.collect_space
      assert_equal 352 , objects.length
    end
  end
end