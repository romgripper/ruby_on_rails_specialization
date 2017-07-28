class Racer
	attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

	def initialize(params={})
		@id = params[:_id].nil? ? params[:id] : params[:_id].to_s
		@number = params[:number].to_i
		@first_name = params[:first_name]
		@last_name = params[:last_name]
		@gender = params[:gender]
		@group = params[:group]
		@secs = params[:secs].to_i
	end

	def save
		params = {
			number: @number,
			first_name: @first_name,
			last_name: @last_name,
			gender: @gender,
			group: @group,
			secs: @secs
		}
		result = self.class.collection.insert_one(params)
		puts result
		@id = result[:_id].first.to_s
	end

	def self.mongo_client
		Mongoid::Clients.default
	end

	def self.collection
		mongo_client[:racers]
	end

	def self.all(prototype={}, sort={number: 1}, skip=0, limit=nil)
		r = collection.find(prototype).sort(sort).skip(skip)
		r = r.limit(limit) if not limit.nil?
		return r
	end

	def self.find id
		id = id === BSON::ObjectId ? id : BSON::ObjectId.from_string(id)
		result = all({_id: id}).first
		return result.nil? ? nil : Racer.new(result)
	end
end
