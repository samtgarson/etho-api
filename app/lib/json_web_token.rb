class JsonWebToken
  def self.encode(payload, expiration = 1.week.from_now)
    payload = payload.dup
    payload['exp'] = expiration.to_datetime.to_i
    JWT.encode(payload, ENV['jwt_secret'])
  end

  def self.decode(token)
    JWT.decode(token, ENV['jwt_secret']).first
  end

  def self.user_from(token)
    id = decode(token)['user_id']
    User.find(id)
  end
end
