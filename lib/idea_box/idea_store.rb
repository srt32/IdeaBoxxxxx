require_relative './database.rb'
require 'yaml/store'
require 'pry'


class IdeaStore
  extend Database

  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.create(attributes)
    database.transaction do
      database['ideas'] ||= [] # SHOULD BE ABLE TO REMOVE THIS LINE
      database['ideas'] << attributes
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.update(id, data)
    old_idea = find(id)
    new_idea = old_idea.to_h.merge(data)
    database.transaction do
      database['ideas'][id] = new_idea
    end
  end

  def self.find_all_by_user_id(user_id)
    all.select{|idea| idea.user_id == user_id}
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.database
    Database.connect
  end

end
