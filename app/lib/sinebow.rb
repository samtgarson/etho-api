class Sinebow
  include Math
  attr_reader :colours

  class << self
    COLOURS = [
      { colour: 'black',   hex: '#000000' },
      { colour: 'silver',  hex: '#C0C0C0' },
      { colour: 'white',   hex: '#FFFFFF' },
      { colour: 'maroon',  hex: '#800000' },
      { colour: 'red',     hex: '#FF0000' },
      { colour: 'olive',   hex: '#808000' },
      { colour: 'yellow',  hex: '#FFFF00' },
      { colour: 'green',   hex: '#008000' },
      { colour: 'lime',    hex: '#00FF00' },
      { colour: 'teal',    hex: '#008080' },
      { colour: 'cyan',    hex: '#00FFFF' },
      { colour: 'navy',    hex: '#000080' },
      { colour: 'blue',    hex: '#0000FF' },
      { colour: 'purple',  hex: '#800080' },
      { colour: 'magenta', hex: '#FF00FF' }
    ]

    %w(hex colours).each do |m|
      define_method("primary_#{m}") do
        COLOURS.map { |c| c.fetch m.singularize.to_sym }
      end
    end
  end

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
