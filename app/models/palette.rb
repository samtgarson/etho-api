class Palette
  include Mongoid::Document

  field :scores, type: Array
  field :primary, type: String

  embedded_in :image

  PRIMARIES = Sinebow.primaries
  RAINBOW = Sinebow.new(50).colours

  def colours
    scores.map { |s| s[:hex] }
  end

  class << self
    def new_from_url(url)
      @url = url
      Palette.new(scores: find_palette, primary: find_primary)
    end

    private

    def find_primary
      primaries_palette.scores(histogram, 1).first.last.hex
    end

    def find_palette
      histogram.map do |c|
        palette_match(c)
          .sort_by { |match| match[:score] }
          .reverse
          .first
      end
    end

    def primaries_palette
      Colorscore::Palette.from_hex(PRIMARIES)
    end

    def histogram
      @histogram ||= Colorscore::Histogram.new(@url, 4).scores
    end

    def palette_match(col)
      RAINBOW.map do |palette_color|
        score = 0
        color_score, color = *col
        score += color_score * distance_penalty(palette_color, adjusted_color(color))

        {
          score: score,
          hex: palette_color.hex
        }
      end
    end

    def adjusted_color(color)
      color.to_hsl.tap { |c| c.s = 0.05 + c.s * (4 - c.l * 2.5) }.to_rgb
    end

    def distance_penalty(col1, col2)
      distance = Colorscore::Metrics.distance(col1, col2)
      (1 - distance)**4
    end
  end
end
