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
end
