require_relative "../helper"
require "risc/interpreter"

module Risc
  module Ticker
    include AST::Sexp
    include InterpreterHelpers

    def setup
      Risc.machine.boot
      do_clean_compile
      Vm.compile_ast( @input )
      Collector.collect_space
      @interpreter = Interpreter.new
      @interpreter.start Risc.machine.init
    end

    # must be after boot, but before main compile, to define method
    def do_clean_compile
    end

  end
end