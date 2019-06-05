require 'conflisp/dsl'

RSpec.describe Conflisp::DSL do
  describe '.define' do
    it 'allows you to define methods' do
      registry = described_class.define do
        fn :my_method, ->(a) do
          a
        end
      end

      expect(registry).to include('my_method' => kind_of(Proc))
      expect(registry['my_method'].call(:foo)).to eq(:foo)
    end
  end
end
