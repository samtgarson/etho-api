class User
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :_id, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :full_name, presence: true

  has_many :images, dependent: :destroy, inverse_of: :user
  has_and_belongs_to_many :tagged_images, class_name: 'Image', inverse_of: :tagged_user

  field :full_name, type: String
  field :bio, type: String
  field :profile_picture, type: String
  field :username, type: String
  field :website, type: String
  field :counts
  field :processed, type: Mongoid::Boolean, default: false
  field :_id

  def self.verify_auth_code(code)
    user = find_or_create_by(_id: Insta.instagram_id_for(code))
    user.update_if_required
    user
  end

  def new_auth_token
    JsonWebToken.encode('user_id' => me)
  end

  def update_if_required
    update_profile if stale?
  end

  def basics
    as_json only: [:_id, :full_name, :username, :profile_picture]
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
    count_colours.each_with_object(rainbow_hash) do |colour, counts|
      counts[colour.first] += colour.last
    end
  end

  private

  def me
    _id
  end

  def update_profile
    Insta.profile(me).attributes.each do |k, v|
      self[k] = v
    end
    process_user_images

    self.processed = true
    save!
  end

  def process_user_images
    new_images = Insta.user_images
    images.delete_all
    images << new_images
  end

  def stale?
    !updated_at || updated_at < 1.day.ago
  end

  def aggregate_and_sort(key)
    aggregate(key).sort_by(&:count).map { |hash| hash[:value] }
  end

  def aggregate(key)
    images.group_by(&key).map do |k, v|
      {
        value: k,
        count: v.count
      }
    end
  end

  def rainbow_hash
    @rainbow_hash ||= Sinebow.new(50).to_hex.each_with_object({}) { |c, o| o[c] = 0 }
  end

  def count_colours
    all_colours.each_with_object(Hash.new(0)) { |c, counts| counts[c] += 1 }
  end

  def all_colours
    images.map { |i| i.palette.colours }.flatten
  end
end
