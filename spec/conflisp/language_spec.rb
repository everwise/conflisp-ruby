# frozen_string_literal: true

require 'conflisp/language'

RSpec.describe Conflisp::Language do
  let(:add) { proc {} }
  let(:registry) do
    {
      'add' => add
    }
  end
  let(:test_lang) { Conflisp::Language.new(registry: registry) }

  describe '.define' do
    it 'creates a new language using the DSL' do
      add = proc {}
      my_lang = Conflisp::Language.define do
        fn :add, add
      end

      expect(my_lang.registry).to include('add' => add)
    end
  end

  describe '#evaluate' do
    let(:expression) { ['add', 1, 2] }
    let(:evaluator) { instance_double(Conflisp::Evaluator) }

    it 'calls out to Conflisp::Evaluator' do
      allow(Conflisp::Evaluator).to receive(:new).with(
        registry: registry,
        globals: {}
      ).and_return(evaluator)

      expect(evaluator).to receive(:resolve).with(expression)

      test_lang.evaluate(expression)
    end
  end

  describe '#extend' do
    it 'allows you to create new languages' do
      subtract = proc {}
      my_lang = test_lang.extend do
        fn :subtract, subtract
      end

      expect(my_lang.registry).to include(
        'add' => add,
        'subtract' => subtract
      )
    end
  end
end
