require_relative "helper"
require "rubyx/rubyxc"

module RubyX
  class TestRubyXCliExecute < MiniTest::Test

    def test_execute
      assert_output(/Running/) {RubyXC.start(["execute" ,"--preload", 
            "--integers=50","--messages=50" , "test/mains/source/add__4.rb"])}
    end
  end
end
