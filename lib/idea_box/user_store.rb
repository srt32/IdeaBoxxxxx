require_relative './database.rb'
require 'yaml/store'
require 'pry'

class UserStore
  extend Database

  def self.all
    users = []
    raw_users.each_with_index do |data, i|
      users << data
    end
    users
  end

  def self.max_id
    max_id_object = all.max_by(&:id)
    max_id_object.id if max_id_object
  end

  def self.raw_users
    database.transaction do |db|
      db['users'] || []
    end
  end

  def self.create(attributes)
    database.transaction do
      database['users'] ||= []
      database['users'] << attributes
    end
  end

  def self.find(id)
    database.transaction do
      database['users'].find{|user| user.id.to_i == id.to_i}
    end
  end

  def self.delete(id)
    database.transaction do
      database['users'].delete_if{|user| user.id == id}
    end
  end

  def self.update(id,data)
    old_data = database.transaction do
      database['users'].select{|user| user.id = id}
    end
    new_data = old_data.first.to_h.merge(data)
    database.transaction do
      database['users'].select{|user| user.id = id}.first.email = new_data["email"]
    end
  end

  def self.database
    Database.connect
  end

end
