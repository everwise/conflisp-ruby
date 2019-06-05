require 'conflisp/language'

RSpec.describe Conflisp::Language do
  let(:registry) do
    {
      'add' => ->(a, b) { a + b }
    }
  end
  let(:test_lang) { Conflisp::Language.new(registry: registry) }

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
      my_lang = test_lang.extend do
        fn :subtract, ->(a, b) { a - b }
      end

      expect(my_lang.registry).to include(
        'add' => kind_of(Proc),
        'subtract' => kind_of(Proc)
      )
    end
  end
end
