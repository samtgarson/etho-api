class User
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :_id, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  has_many :images, dependent: :destroy, inverse_of: :user, autosave: true
  has_and_belongs_to_many :tagged_images, class_name: 'Image', inverse_of: :tagged_user

  field :full_name, type: String
  field :bio, type: String
  field :profile_picture, type: String
  field :username, type: String
  field :website, type: String
  field :counts
  field :_id, type: String
  field :processed, type: Mongoid::Boolean, default: false
  field :token, type: String

  def self.verify_auth_code(opts)
    user = find_or_create_by(_id: Insta.instagram_id_for(opts))
    user.update_attributes(token: Insta.access_token)
    user.update_if_required
    user
  end

  def new_auth_token
    JsonWebToken.encode('user_id' => me)
  end

  def basics
    as_json only: [:_id, :full_name, :username, :profile_picture]
  end

  def update_if_required
    update if stale? || !processed
  end

  private

  def me
    _id
  end

  def update
    update_profile
    update_images
    save!
  end

  def update_profile
    Insta.profile(me).attributes.each do |k, v|
      self[k] = v unless k == '_id'
    end
  end

  def update_images
    new_images = Insta.user_images
    new_images.each do |i|
      Image.where(_id: i._id).find_one_and_update(i.as_json, upsert: true)
    end
    self.processed = true
  end

  def stale?
    !updated_at || updated_at < 1.day.ago
  end
end
