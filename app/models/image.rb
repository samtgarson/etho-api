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
  field :created_time, type: DateTime
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
end
