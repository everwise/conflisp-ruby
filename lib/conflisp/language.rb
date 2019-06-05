require 'conflisp/dsl'
require 'conflisp/evaluator'

module Conflisp
  class Language
    attr_reader :registry

    def initialize(registry:)
      @registry = registry
    end

    def evaluate(expression, globals: {})
      evaluator = Evaluator.new(registry: registry, globals: globals)
      evaluator.resolve(expression)
    end

    def extend(&block)
      new_registry = DSL.define(&block)
      self.class.new(registry: registry.merge(new_registry))
    end
  end
end
