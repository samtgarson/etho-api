class Image
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  validates :_id, presence: true, uniqueness: true

  belongs_to :user
  has_and_belongs_to_many :tagged_users, class_name: 'User', inverse_of: :tagged_image

  field :tags, type: Array
  field :location
  field :filter
  field :comments, type: Integer
  field :created_time, type: DateTime
  field :likes, type: Integer
  field :link
  field :caption
  field :_id
  field :type

  field :url
  field :palette, type: Array
  field :processed, type: Mongoid::Boolean, default: false
  field :season

  def video?
    type != 'image'
  end
end
