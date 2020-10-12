# frozen_string_literal: true

require 'conflisp/method_missing'
require 'conflisp/runtime_error'

module Conflisp
  # Evaluator takes s-expressions and resolves them into Ruby values
  class Evaluator
    attr_reader :registry, :globals

    def initialize(registry:, globals:)
      @registry = registry
      @globals = globals
    end

    def resolve(expression) # rubocop:disable Metrics/MethodLength
      case expression
      when Array
        # In Lisp, Arrays are function calls
        fn_name, *raw_args = expression
        fn_name = fn_name.to_s
        args = raw_args.map { |arg| resolve(arg) }
        if fn_name == 'global'
          globals.dig(*args)
        else
          apply(fn_name, *args)
        end
      when Hash
        expression.transform_values do |value|
          resolve(value)
        end
      else
        expression
      end
    rescue Conflisp::ConflispError => e
      e.conflisp_stack << expression
      raise e
    end

    def apply(fn_name, *args)
      method = registry[fn_name]
      raise Conflisp::MethodMissing, fn_name unless method

      begin
        instance_exec(*args, &method)
      rescue StandardError => e
        raise Conflisp::RuntimeError.new(e, [fn_name, *args])
      end
    end
  end
end
