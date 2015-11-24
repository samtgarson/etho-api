class Sinebow
  include Math
  attr_reader :colours

  def initialize(number_of_colours = 10)
    @colours = []

    number_of_colours.times do |i|
      @colours << get_colour(i.to_f / number_of_colours)
    end
  end

  def to_hex
    @colours.map(&:hex)
  end

  private

  def get_colour(i)
    @hue = i * -1 + 0.5
    Color::RGB.new(*colour_array)
  end

  def colour_array
    fraction_array.map { |v| 255 * v**2 }
  end

  def fraction_array
    r = sin(PI * @hue)
    g = sin(PI * (@hue + 1.0 / 3))
    b = sin(PI * (@hue + 2.0 / 3))
    [r, g, b]
  end
end
