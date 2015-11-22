class ImageAction
  include Mongoid::Document
  include Mongoid::Timestamps::Updated

  belongs_to :image
  belongs_to :user
  field :created_at, type: Date
  field :text, type: String
  field :type, type: Symbol
end
