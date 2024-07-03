# frozen_string_literal: true

class Star
  def self.build(...)
    new(...)
  end

  private_class_method def self.some_class_privates1; end
  private_class_method def self.some_class_privates2; end
  private_class_method def self.some_class_privates3; end

  attr_reader :lon, :lat, :size

  def initialize(lon:, lat:, size:)
    @lon = lon
    @lat = lat
    @size = size
  end

  def shape
    %w[circle square].sample
  end

  def to_h
    { lon: lon, lat: lat, size: size }
  end

  private

  def some_privates
    1
  end
end
