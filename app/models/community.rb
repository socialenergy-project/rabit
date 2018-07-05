class Community < ApplicationRecord
  belongs_to :clustering
  has_and_belongs_to_many :consumers
  has_many :recommendations, dependent: :restrict_with_exception, as: :recommendable

  validate :consumer_belongs_to_only_one_community_per_clustering

  include Recommendable

  def consumer_belongs_to_only_one_community_per_clustering
    (clustering.communities - [self]).each do |community|
      collisions = consumer_ids.select{|c| community.consumer_ids.include? c }
      if collisions.count > 0
        errors.add(:consumer_ids, "Consumers \"#{Consumer.find(collisions).map(&:name).join(", ")}\" are in " \
                   "community \"#{community.name}\", which is also in clustering \"#{clustering.name}\".")
      end
    end if clustering
  end

  def realtime
    (consumers.first || Consumer.first)&.consumer_category&.name == "ICCS"
  end

  def initDates
    (consumers.first || Consumer.first)&.initDates
  end
end
