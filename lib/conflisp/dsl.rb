# frozen_string_literal: true

module Conflisp
  # A nice helper DSL for building up Conflisp languages
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
