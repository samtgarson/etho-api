class Image
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  before_create :process_colours

  validates :_id, presence: true, uniqueness: true

  belongs_to :user
  has_and_belongs_to_many :tagged_users, class_name: 'User', inverse_of: :tagged_image
  embeds_one :palette

  field :tags, type: Array
  field :location
  field :filter
  field :comments, type: Integer
  field :created_at, type: DateTime
  field :likes, type: Integer
  field :link
  field :caption
  field :_id
  field :type, type: Symbol

  field :urls, type: Hash
  field :processed, type: Mongoid::Boolean, default: false
  field :season, type: Symbol

  def video?
    type != :image
  end

  def process_colours
    self.palette ||= Palette.new_from_url(urls[:small])
  end

  def season
    %i(spring summer autumn).each do |season|
      return season if send(season).cover? days_into_year
    end
    :winter
  end

  def time_of_day
    return :day if created_at >= morning && created_at < evening
    :night
  end

  def primary
    palette.primary
  end

  private

  def days_into_year
    (created_at - created_at.beginning_of_year).to_i
  end

  def spring
    59..151
  end

  def summer
    152..243
  end

  def autumn
    244..334
  end

  def morning
    created_at.change(hour: 2, minute: 0, second: 0)
  end

  def evening
    created_at.change(hour: 19, minute: 30, second: 0)
  end
end
