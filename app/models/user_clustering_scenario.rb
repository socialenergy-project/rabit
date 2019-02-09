class UserClusteringScenario < ApplicationRecord
    has_many :user_clustering_parameters, dependent: :destroy
    has_many :user_clustering_results, dependent: :destroy

    def get_params
        self.user_clustering_parameters.each_with_object({}) {|v,h| h[v.user_id] ||= {}; h[v.user_id][v.paramtype] ||= v.value }
    end
end
