class Palette
  include Mongoid::Document

  field :scores, type: Array
  field :primary, type: String

  embedded_in :image

  PRIMARIES = Sinebow.primary_hex.map { |c| Color::RGB.by_hex c }
  RAINBOW = Sinebow.new(50).colours

  class << self
    def new_from_url(url)
      @url = url
      @histogram = nil
      Palette.new(
        scores: merged_palette.sort_by { |s| s[:score] }.reverse,
        primary: find_primary)
    end

    private

    def find_primary
      histogram.first.last.closest_match(PRIMARIES).hex
    end

    def merged_palette
      filtered_palette
        .group_by { |s| s[:hex] }
        .map do |h, s|
        {
          hex: h,
          score: s.inject(0) { |a, e| a + e[:score] }
        }
      end
    end

    def filtered_palette
      find_palette
        .delete_if { |s| s[:score] == 0 }
    end

    def find_palette
      histogram.map { |c| palette_match(c) }
    end

    def primaries_palette
      Colorscore::Palette.from_hex(PRIMARIES)
    end

    def histogram
      @histogram ||= Colorscore::Histogram.new(@url, 16).scores
    end

    def palette_match(col)
      score, color = *col
      new_color = color.closest_match(RAINBOW)
      distance = delta(color, new_color)

      {
        score: normalize(score, distance).to_i,
        hex: new_color.hex
      }
    end

    def delta(col1, col2)
      col1.delta_e94(col1.to_lab, col2.to_lab)
    end

    def normalize(score, distance)
      (2 / distance) * score * 400
    end

    def adjusted_color(color)
      color.to_hsl.tap { |c| c.s = 0.05 + c.s * (4 - c.l * 2.5) }.to_rgb
    end
  end
end
