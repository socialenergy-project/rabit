class Community < ApplicationRecord
  belongs_to :clustering
  has_and_belongs_to_many :consumers

  validate :consumer_belongs_to_only_one_community_per_clustering

  def consumer_belongs_to_only_one_community_per_clustering
    (clustering.communities - [self]).each do |community|
      collisions = consumer_ids.select{|c| community.consumer_ids.include? c }
      if collisions.count > 0
        errors.add(:consumer_ids, "Consumers \"#{Consumer.find(collisions).map(&:name).join(", ")}\" are in " \
                   "community \"#{community.name}\", which is also in clustering \"#{clustering.name}\".")
      end
    end if clustering
  end

  def initDates
    (consumers.first || Consumer.first)&.initDates
  end
end
