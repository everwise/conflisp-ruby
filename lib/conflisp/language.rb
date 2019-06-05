require 'conflisp/evaluator'

module Conflisp
  class Language
    attr_reader :registry

    def initialize(registry:)
      @registry = registry
    end

    # TODO: merge & extend

    def evaluate(expression, globals: {})
      evaluator = Evaluator.new(registry: registry, globals: globals)
      evaluator.resolve(expression)
    end
  end
end
