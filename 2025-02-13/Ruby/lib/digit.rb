require_relative './segment'

class Digit
  def initialize(segments)
    @top_segment = segments[0]
    @middle_segment = segments[1]
    @bottom_segment = segments[2]
  end

  def value
    [
      @top_segment,
      @middle_segment,
      @bottom_segment
    ]
  end

  # flat array of characters
  def chars
    [@top_segment, @middle_segment, @bottom_segment].map(&:chars).flatten
  end

  def distance_from_digit(digit)
    different_chars = 0

    my_chars = chars
    digit_chars = digit.chars

    my_chars.each_with_index do | char, index |
      if char != digit_chars[index]
        different_chars += 1
      end
    end

    different_chars
  end
end
