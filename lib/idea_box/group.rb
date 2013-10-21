class Group

  attr_reader :name,
              :user_id

  attr_accessor :id

  def initialize(attributes)
    @name = attributes[:name]
    @user_id = attributes[:user_id]
  end

  def ideas
    IdeaStore.find_all_by_group_id(self.id.to_i)
  end

end
