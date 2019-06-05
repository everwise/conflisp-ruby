module Conflisp
  class DSL
    attr_reader :registry

    def self.define(&block)
      registry = {}
      dsl = new(registry: registry)
      dsl.instance_exec(&block)
      registry
    end

    def initialize(registry:)
      @registry = registry
    end

    def fn(name, implementation)
      registry[name.to_s] = implementation
    end
  end
end
