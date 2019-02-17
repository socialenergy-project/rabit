require 'fetch_data/participation_client.rb'
require 'kmeans-clusterer'


module ClusteringModule

    class UserClustering

        def initialize(kappa = 5, values = nil)
            @kappa = kappa
            @values = values || UserClustering.parameterTypes.keys

            begin
                pc = FetchData::ParticipationClient.new

                pc.get_stats
            rescue
            end


        end

        def run(user_ids)
            clusters = cluster_simple user_ids
            clusters.map do |c| 
                c.points.map(&:label)
            end
        end

        def cluster_simple(user_ids)
            labels = user_ids
            data = labels.map do |u|
                @values.map do |v|
                    UserClustering.parameterTypes[v.to_sym].call(u)
                end
            end

            # p "The data is #{[data, labels]}"

            kmeans = KMeansClusterer.run @kappa, data, labels: labels, runs: 5, scale_data: true

            # kmeans.clusters.each do |cluster|
            # puts  cluster.id.to_s + '. ' +
            #         cluster.points.map(&:label).join(", ") + "\t" +
            #       cluster.centroid.to_s
            # end

#            # Use existing clusters for prediction with new data:
#            predicted = kmeans.predict [[41.85,-87.65]] # Chicago
#            puts "\nClosest cluster to Chicago: #{predicted[0]}"

            # Clustering quality score. Value between -1.0..1.0 (1.0 is best)
            # puts "\nSilhouette score: #{kmeans.silhouette.round(2)}"
            kmeans.clusters
        end

        def self.parameterTypes
            {
                game_score: ->(u) {
                    GameActivity.get_current_score(u)
                },
                game_activity: ->(u) {
                    GameActivity.get_total_time_played(u)
                },
                lcms_badge_count: ->(u) {
                    LcmsBadge.where(user_id: u).count
                },
                lcms_activity: ->(u) {
                    LcmsCourse.get_total_time_played(u)
                },
                lcms_score: ->(u) {
                    LcmsScore.get_current_score(u)
                },
            }
        end

    end
end