class UserBuilder
  attr_reader :user

  def initialize(hash = {})
    process(hash)
  end

  private

  def process(hash)
    @user = User.new
    completed_hash(hash).each do |a, v|
      @user[a] = v if @user.respond_to?(a)
    end

    @user
  end

  def completed_hash(hash)
    hash.tap do |h|
      h[:_id] = h[:id].to_i
    end
  end
end
