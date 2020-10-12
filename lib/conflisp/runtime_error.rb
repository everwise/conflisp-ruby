# frozen_string_literal: true

require 'conflisp/conflisp_error'

module Conflisp
  # Error raised when evaluation of a Conflisp expression fails
  class RuntimeError < ConflispError
    attr_reader :original_error

    def initialize(error, expression)
      message = "#{error.class.name}: #{error.message}"
      message += "\n  while evaluating #{expression}"
      super(message)

      @original_error = error
    end
  end
end
