# frozen_string_literal: true

module Conflisp
  # Base class for ConflispError
  class ConflispError < StandardError
    attr_reader :conflisp_stack

    def initialize(*args)
      super

      @conflisp_stack = []
    end

    def to_s
      ret = super

      conflisp_stack.each do |expression|
        ret += "\n  in expression #{expression}"
      end

      ret
    end
  end
end
