class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token, type: String
  field :name, type: String
  field :bio, type: String
  field :profile_picture, type: String
  field :username, type: String
  field :website, type: String
  field :counts, type: Hash
  field :processed, type: Mongoid::Boolean
  field :_id, type: Integer
end
