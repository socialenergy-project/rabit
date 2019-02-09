class UserClusteringParameter < ApplicationRecord
  belongs_to :user_clustering_scenario
  belongs_to :user
end
