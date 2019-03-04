require_relative "../helper"

module RubyX

  module RubyXHelper
    def setup
    end
    def ruby_to_risc(input , options = {})
      mom = ruby_to_mom(input)
      mom.translate(options[:platform] || :interpreter)
    end
    def ruby_to_vool(input, options = {})
      RubyXCompiler.new(RubyX.default_test_options).ruby_to_vool(input)
    end
    def ruby_to_mom(input , options = {})
      RubyXCompiler.new(RubyX.default_test_options).ruby_to_mom(input)
    end
    def compile_in_test( input , options = {})
      vool = ruby_to_vool in_Test(input)
      vool.to_mom(nil)
      itest = Parfait.object_space.get_class_by_name(:Test)
      assert itest
      itest
    end

  end
end
