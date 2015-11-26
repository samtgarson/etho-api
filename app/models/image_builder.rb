class ImageBuilder
  attr_reader :image
  attr_accessor :attributes

  def initialize(hash)
    @attributes = hash
    process
  end

  private

  def process
    @image = Image.new
    completed_hash.each do |a, v|
      @image[a] = v if @image.respond_to?(a)
    end

    tag_users

    @image
  end

  def completed_hash
    transformed_hash.tap do |h|
      h[:_id] = h[:id]
      h[:urls] = h[:images]
      h[:user_id] = find_user(h[:user])
    end
  end

  def transformed_hash
    @attributes.each do |attr, value|
      begin
        @attributes[attr] = send(attr, value)
      rescue NoMethodError
        @attributes[attr] = value
      end
    end
  end

  def caption(value)
    value.text
  end

  def created_time(value)
    Time.at(value.to_i).to_datetime
  end

  def images(value)
    {
      big: value['standard_resolution']['url'],
      small: value['low_resolution']['url']
    }
  end

  def tags(value)
    value.map(&:to_sym)
  end

  def type(value)
    value.to_sym
  end

  def find_user(value)
    User.find_by(value)._id
  end

  def tag_users
    @attributes['users_in_photo'].each do |u|
      @image.tagged_users << User.find_or_create_by(u['user'].to_hash)
    end
  end

  def likes(value)
    value['count'].to_i
  end

  def comments(value)
    value['count'].to_i
  end
end
