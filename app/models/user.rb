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
end
