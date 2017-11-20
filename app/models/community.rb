class Community < ApplicationRecord
  belongs_to :clustering
  has_and_belongs_to_many :consumers


  validate :consumer_belongs_to_only_one_community_per_clustering

  def consumer_belongs_to_only_one_community_per_clustering
    p "Error checking: #{consumer_ids}, #{(clustering.communities - [self]).map(&:consumer_ids).flatten}"
    if consumer_ids.any?{|c| (clustering.communities - [self]).map(&:consumer_ids).flatten.include?(c)  }
      errors.add(:consumer, "Consumers can't belong in two communities in the same clustering")
    end

  end
end
