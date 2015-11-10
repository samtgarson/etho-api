class User
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :_id, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :counts, presence: true

  field :full_name, type: String
  field :bio, type: String
  field :profile_picture, type: String
  field :username, type: String
  field :website, type: String
  field :counts
  field :processed, type: Mongoid::Boolean, default: false
  field :_id, type: Integer

  def self.verify_auth_code(code)
    user = find_or_create_by(_id: InstagramWrapper.id_for(code))
    user.update_if_required
  end

  def new_auth_token
    JsonWebToken.encode('user_id' => me)
  end

  def update_if_required
    if !processed && stale?
      update_profile
      process_user_images
      save
    end
    self
  end

  private

  def me
    _id
  end

  def update_profile
    InstagramWrapper.profile(me).attributes.each do |k, v|
      self[k] = v
    end
  end

  def process_user_images
    # nothing yet
  end

  def stale?
    !updated_at || updated_at < 1.day.ago
  end

  def processed?
    processed
  end
end
