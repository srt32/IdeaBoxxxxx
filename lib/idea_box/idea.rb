class Idea
  include Comparable

  attr_reader :title, :description, :rank, :id, :user_id

  def initialize(attributes = {})
    @title = attributes["title"]
    @description = attributes["description"]
    @rank = attributes["rank"] || 0
    @id = attributes["id"]
    @user_id = attributes["user_id"]
  end

  def like!
    @rank = @rank.to_i + 1
  end

  def save
    IdeaStore.create(to_h)
  end

  def <=>(other)
    other.rank <=> rank
  end

  def to_h
    {
      "title" => title,
      "description" => description,
      "rank" => rank,
      "id" => id,
      "user_id" => user_id
    }
  end

end
