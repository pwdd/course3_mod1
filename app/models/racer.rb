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
end