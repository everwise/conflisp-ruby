# frozen_string_literal: true

require 'conflisp/conflisp_error'

module Conflisp
  # Error raised when a function is not found
  class MethodMissing < ConflispError
    def initialize(fn_name)
      message = "Unknown fn `#{fn_name}`"
      super(message)
    end
  end
end
