require 'conflisp/method_missing'

module Conflisp
  class Evaluator
    attr_reader :registry, :globals

    def initialize(registry:, globals:)
      @registry = registry
      @globals = globals
    end

    def resolve(expression)
      case expression
      when Array
        # In Lisp, Arrays are function calls
        fn, *raw_args = expression
        fn = fn.to_s
        args = raw_args.map { |arg| resolve(arg) }
        if fn == 'global'
          globals.dig(*args)
        elsif fn_defined?(fn)
          apply(fn, *args)
        else
          # TODO: It would be nice to get error messages with a stacktrace or at
          # least some context about the parent expressions
          raise MethodMissing, "Unknown fn #{fn} in expression #{expression}"
        end
      when Hash
        expression.transform_values do |value|
          resolve(value)
        end
      else
        expression
      end
    end

    def fn_defined?(fn)
      registry.key?(fn)
    end

    def apply(fn, *args)
      instance_exec(*args, &registry[fn])
    end
  end
end
