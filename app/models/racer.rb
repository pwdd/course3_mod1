class Racer
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