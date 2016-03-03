class Racer
  attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

  def initialize(params={})
    @id = params[:_id].nil? ? params[:id] : params[:_id].to_s
    @number = params[:number].to_i ||= nil
    @first_name = params[:first_name] ||= nil
    @last_name = params[:last_name] ||= nil
    @gender = params[:gender] ||= nil
    @group = params[:group] ||= nil
    @secs = params[:secs].to_i ||= nil
  end

  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    mongo_client[:racers]
  end

  def self.load_file(path)
    file = File.read(path)
    hash = JSON.parse(file)
    collection.insert_many(hash)
  end

  def self.all(prototype={}, sort={}, offset=0, limit=nil)
    docs = collection.find(prototype)
                     .sort(sort)
                     .skip(offset)
    limit.nil? ? docs : docs.limit(limit)
  end

  def self.find(id)
    doc = collection.find(_id: BSON::ObjectId.from_string(id)).first
    doc.nil? ? nil : Racer.new(doc)
  end

  def save
    doc = self.class.collection.insert_one(
                                           number: @number,
                                           first_name: @first_name,
                                           last_name: @last_name,
                                           gender: @gender,
                                           group: @group,
                                           secs: @secs
      )
    @id = doc.inserted_id.to_s
  end
end
