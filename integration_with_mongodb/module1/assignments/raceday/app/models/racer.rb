class Racer

	include ActiveModel::Model

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
		self.class.collection.find_one_and_replace(params, params, {upsert: true})
		@id = self.class.all(params).first[:_id].to_s
	end

	def update params
		@number = params[:number].to_i
		@first_name = params[:first_name]
		@last_name = params[:last_name]
		@secs = params[:secs].to_i
		@gender = params[:gender]
		@group = params[:group]
		id = BSON::ObjectId.from_string(@id)
		params[:_id] = id
		params.slice!(:_id, :number, :first_name, :last_name, :gender, :group, :secs)
		self.class.collection.replace_one({_id: id}, params)
	end

	def destroy
		self.class.collection.delete_one({number: @number})
	end

	def persisted?
		!@id.nil?
	end

	def created_at
		nil
	end

	def updated_at
		nil
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
		id = id.is_a?(BSON::ObjectId) ? id : BSON::ObjectId.from_string(id)
		result = all({_id: id}).first
		return result.nil? ? nil : Racer.new(result)
	end

	def self.paginate params
		page = (params[:page] || 1).to_i
		limit = (params[:per_page] || 30).to_i
		skip = (page - 1) * limit

		racers = []
		all({}, {}, skip, limit).each do |doc|
			racers << Racer.new(doc)
		end
		total = all.count

		WillPaginate::Collection.create(page, limit, total) do |pager|
			pager.replace(racers)
		end
	end	
end
