require 'conflisp/dsl'
require 'conflisp/language'

module Conflisp
  def self.define(&block)
    method_registry = DSL.define(&block)
    Language.new(registry: method_registry)
  end
end
