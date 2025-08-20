require_relative './digit'

class PolicyNumber

  # @param rows [Array<String>]
  def self.from_rows(rows:)
    new(rows:)
  end

  # @param rows [Array<String>]
  def initialize(rows:)
    @rows = rows
  end

  # @return [Array<Digit>]
  def digits
    @rows.map { |row| row.scan(/.{1,3}/) } => [first, second, third]

    first.map.with_index { |digit, idx| Digit.new([digit, second[idx], third[idx]]) }
  end

  def digit_values
    digits.map { |digit| digit.value }
  end

  def close_digits
  end
end
