# frozen_string_literal: true

require_relative '../../src/shared_kernel/validation'

RSpec.describe Validation do
  before(:all) do
    class ValidationFake < Validation
      params do
        required(:dummy_param).filled(:string)
      end
    end
  end

  context 'when a basic schema is defined' do
    it 'returns errors for missing required parameters' do
      sut = ValidationFake.new.call({})

      expect(sut.success?).to be false
      expect(sut.errors[:dummy_param]).to include('is missing')
    end

    it 'validates with provided parameters' do
      sut = ValidationFake.new.call(dummy_param: 'value')

      expect(sut.success?).to be true
      expect(sut.errors).to be_empty
    end

    it 'fails validation for incorrect field types' do
      sut = ValidationFake.new.call(dummy_param: 123)

      expect(sut.success?).to be false
      expect(sut.errors[:dummy_param]).to include('must be a string')
    end
  end
end
