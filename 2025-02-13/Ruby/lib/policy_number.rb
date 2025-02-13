require_relative './constants'

class PolicyNumber

  # @param rows [Array<String>]
  def self.from_rows(rows:)
    new(rows:)
  end

  # @param rows [Array<String>]
  def initialize(rows:)
    @rows = rows
  end

  # @return [Array<Array[String]>]
  def digits
    @rows.map { |row| row.scan(/.{1,3}/) } => [first, second, third]

    first.map.with_index { |digit, idx| [digit, second[idx], third[idx]] }
  end

  def close_digits
    return_array = []
    digits.each do |digit|
      potential_matches = []
      Constants::DIGITS.each do |k, v|
        number = v.join
        number_same = check_equal(number.chars, digit.join.chars)
        potential_matches << k if number_same
      end
      return_array << potential_matches
    end
    return_array
  end

  def check_equal(chars, digit_chars)
    number_same = 0
    chars.each_with_index do |char, idx|
      number_same += 1 if digit_chars[idx] == char
    end
    number_same >= 8
  end
end