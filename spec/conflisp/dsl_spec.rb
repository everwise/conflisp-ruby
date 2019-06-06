# frozen_string_literal: true

require 'conflisp/dsl'

RSpec.describe Conflisp::DSL do
  describe '.define' do
    it 'allows you to define methods' do
      my_method = proc {}
      registry = described_class.define do
        fn :my_method, my_method
      end

      expect(registry).to include('my_method' => my_method)
    end
  end
end
