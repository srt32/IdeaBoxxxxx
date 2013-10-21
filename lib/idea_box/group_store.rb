require_relative './database'
require 'yaml/store'

class GroupStore
  extend Database

  def self.create(group_obj)
    group_obj.id = assign_pk
    database.transaction do
      database['groups'] ||= []
      database['groups'] << group_obj
    end
  end

  def self.all
    groups = []
    raw_groups.each do |group|
      groups << group
    end
    groups
  end

  def self.raw_groups
    database.transaction do |db|
      db['groups'] || []
    end
  end

  def self.assign_pk
    max_id ? max_id + 1 : 1
  end

  def self.max_id
    max_id_object = all.max_by(&:id)
    max_id_object.id if max_id_object
  end

  def self.database
    Database.connect
  end

end
