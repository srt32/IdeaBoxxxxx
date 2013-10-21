class Group

  attr_reader :name,
              :user_id,
              :id

  def initialize(attributes)
    @name = attributes[:name]
    @user_id = attributes[:user_id]
  end

end
