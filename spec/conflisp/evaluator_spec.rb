# frozen_string_literal: true

require 'conflisp/evaluator'

RSpec.describe Conflisp::Evaluator do
  let(:registry) do
    {
      'add' => ->(a, b) { a + b }
    }
  end
  let(:globals) { {} }
  let(:evaluator) { described_class.new(registry: registry, globals: globals) }

  describe '#resolve' do
    it 'evaluates the expression' do
      expect(evaluator.resolve(['add', 1, 2])).to eq(3)
    end

    it 'can evaluate nested expressions' do
      expect(evaluator.resolve(['add', ['add', 1, 2], 3])).to eq(6)
    end

    # it 'can evaluate nested expressions of arbitrary depth' do
    #   expression = ['add', 0, 1]
    #   3843.times do
    #     expression = ['add', expression, 1]
    #   end
    #   expect(evaluator.resolve(expression)).to eq(3844)
    # end

    it 'supports JSON scalar values' do
      expect(evaluator.resolve('a')).to eq('a')
      expect(evaluator.resolve(1)).to eq(1)
      expect(evaluator.resolve(nil)).to be_nil
      expect(evaluator.resolve(true)).to eq(true)
      expect(evaluator.resolve(false)).to eq(false)
    end

    it 'supports JSON objects' do
      expression = {
        'foo' => ['add', 1, 2]
      }
      expect(evaluator.resolve(expression)).to eq('foo' => 3)
    end

    context 'when calling nonexistent functions' do
      it 'throws an error' do
        message = 'Unknown fn nonexistent in expression ["nonexistent", 1, 2]'
        expect {
          evaluator.resolve(['nonexistent', 1, 2])
        }.to raise_error(Conflisp::MethodMissing, message)
      end
    end

    context 'when passing in globals' do
      let(:globals) do
        {
          'foo' => 'bar',
          'a' => { 'b' => 'c' }
        }
      end

      it 'gives you access to globals' do
        expect(evaluator.resolve(['global', 'foo'])).to eq('bar')
      end

      it 'can resolve through nested hashes' do
        expect(evaluator.resolve(['global', 'a', 'b'])).to eq('c')
      end

      it 'a nonexistent key will give you nil' do
        expect(evaluator.resolve(['global', 'nonexistent'])).to be_nil
      end
    end

    context 'when trying to call functions from other functions' do
      let(:registry) do
        {
          'add1' => ->(a, b) { a + b },
          'add2' => ->(a, b) { resolve(['add1', a, b]) }
        }
      end

      it 'will allow you to resolve expressions' do
        expect(evaluator.resolve(['add2', 1, 2])).to eq(3)
      end
    end
  end
end
