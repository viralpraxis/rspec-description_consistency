# frozen_string_literal: true

RSpec.describe Star do
  subject(:star) { described_class.build(lon: 1, lat: 2, size: 42) }

  describe '.build' do
    it { expect(described_class).to respond_to(:build) }
  end

  describe '.rebuild' do
    it { expect(described_class).not_to respond_to(:rebuild) }
  end

  describe '.some_class_privates1' do
    it { expect(described_class.singleton_class.private_instance_methods).to include(:some_class_privates1) }
  end

  describe '.some_class_privates2', :private do
    it { expect(described_class.singleton_class.private_instance_methods).to include(:some_class_privates2) }
  end

  describe '.some_class_privates3', description_consistency: false do
    it { expect(described_class.singleton_class.private_instance_methods).to include(:some_class_privates3) }
  end

  describe '#lon' do
    it { expect(star.lon).to eq(1) }
  end

  describe '#latitude' do
    it { expect(star.lat).to eq(2) }
  end

  describe '#some_privates' do
    it { expect(star.send(:some_privates)).to eq(1) }
  end
end
