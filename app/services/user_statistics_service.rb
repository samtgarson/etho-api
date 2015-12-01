class UserStatisticsService
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def season
    aggregate_and_sort(:season).last
  end

  def time_of_day
    aggregate_and_sort(:time_of_day).last
  end

  def favourite_colour
    Color::RGB.by_hex(aggregate_and_sort(:primary).last).name
  end

  def colours
    colours_hash.map do |k, v|
      {
        colour: k,
        count: v
      }
    end
  end

  def tags
    {
      average: average_tags.round,
      max: tag_counts.last[:count],
      top_tags: top_tags.map { |t| { tag: t.first, count: t.last } }
    }
  end

  private

  def aggregate_and_sort(key)
    aggregate(key).sort_by { |h| h[:count] }.map { |hash| hash[:value] }
  end

  def aggregate(key)
    user.images.group_by(&key).map do |k, v|
      {
        value: k,
        count: v.count
      }
    end
  end

  def rainbow_hash
    @rainbow_hash ||= Sinebow.new(50).to_hex.each_with_object({}) { |c, o| o[c] = 0 }
  end

  def colours_hash
    count_colours_occurence.each_with_object(rainbow_hash) do |colour, counts|
      counts[colour.first] += colour.last
    end
  end

  def top_tags
    count_tag_occurence[-5, 5] || count_tag_occurence
  end

  def average_tags
    tag_counts.map(&:count).inject(:+).to_f / tag_counts.count
  end

  def tag_counts
    @tag_counts ||= user.images
                    .map { |i| { image: i._id, count: i.tags.count } }
                    .sort_by { |_k, v| v }.sort_by { |h| h[:count] }
  end

  def count_colours_occurence
    @colour_occurence ||= all_colours.each_with_object(Hash.new(0)) { |c, counts| counts[c] += 1 }
  end

  def count_tag_occurence
    @tag_occurence ||= all_tags
                       .each_with_object(Hash.new(0)) { |t, counts| counts[t] += 1 }
                       .sort_by(&:last)
  end

  def all_colours
    @all_colours ||= user.images.map { |i| i.palette.colours }.flatten
  end

  def all_tags
    @all_tags ||= user.images.map(&:tags).flatten
  end
end
