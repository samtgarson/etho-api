class UserStatisticsService
  SAMPLE_SIZE = 85

  def initialize(user)
    @user = user
  end

  def season
    aggregate_and_sort(:season).last if user_has_images?
  end

  def time_of_day
    aggregate_and_sort(:time_of_day).last if user_has_images?
  end

  def favourite_colour
    Color::RGB.by_hex(aggregate_and_sort(:primary, :processed).last).name if user_has_images?
  end

  def colours
    colours_hash.map do |k, v|
      {
        colour: k,
        count: v
      }
    end if user_has_images?
  end

  def tags
    {
      average: average_tags.round,
      max: tag_counts.last[:count],
      top_tags: top_tags.reverse.map { |t| { tag: t.first, count: t.last } }
    } if user_has_images?
  end

  private

  attr_reader :user

  def user_has_images?
    @user.images.any?
  end

  def aggregate_and_sort(key, scope = nil)
    aggregate(key, scope).sort_by { |h| h[:count] }.map { |hash| hash[:value] }
  end

  def aggregate(key, scope = nil)
    set = user.images
    set = set.send(scope) if scope
    grouped_set = set.group_by(&key).map do |k, v|
      {
        value: k,
        count: v.count
      }
    end
    grouped_set.reject { |k, _a| k.blank? }
  end

  def rainbow_hash
    @rainbow_hash ||= Sinebow.new(50).to_hex.each_with_object({}) { |c, o| o[c] = 0 }
  end

  def colours_hash
    count_colours_occurence.each_with_object(rainbow_hash) do |(hex, score), counts|
      counts[hex] += score
    end
  end

  def top_tags(num = 5)
    count_tag_occurence[-num, num] || count_tag_occurence
  end

  def average_tags
    tag_counts.map(&:count).inject(:+).to_f / tag_counts.count
  end

  def tag_counts
    @tag_counts ||= user.images
                    .map { |i| { image: i._id, count: i.tags.count } }
                    .sort_by { |_k, v| v }.sort_by { |h| h[:count] }
  end

  def count_tag_occurence
    @tag_occurence ||= all_tags
                       .each_with_object(Hash.new(0)) { |t, counts| counts[t] += 1 }
                       .sort_by(&:last)
  end

  def all_tags
    @all_tags ||= user.images.map(&:tags).flatten
  end

  def count_colours_occurence
    @colour_occurence ||= all_colours
                          .group_by { |s| s[:hex] }
                          .each_with_object(Hash.new(0)) do |(hex, scores), hash|
                            hash[hex] += sum_of_scores(scores)
                          end
  end

  def sum_of_scores(scores)
    scores.inject(0) { |a, e| a + e[:score] }
  end

  def all_colours
    @all_colours ||= processed_images.map { |i| i.process_colours.scores }.flatten
  end

  def processed_images
    processed = user.images.processed
    processed += user.images.unprocessed.sample(SAMPLE_SIZE) unless processed.length == user.counts[:media]
    processed
  end
end
