require 'fetch_data/participation_client.rb'
require 'kmeans-clusterer'


module ClusteringModule

    class UserClustering

        def initialize(kappa = 5)
            @kappa = kappa

            pc = FetchData::ParticipationClient.new

            pc.get_stats

        end

        def cluster_simple
            labels = User.where(provider: 'Gsrn').pluck :id
            data = labels.map do |u|
                [
                    GameActivity.get_current_score(u),
                    GameActivity.get_total_time_played(u),
                    LcmsBadge.where(user_id: u).count,
                    LcmsCourse.where(user_id: u).count,
                    LcmsScore.get_current_score(u),
                ]
            end

            p "The data is #{[data, labels]}"

            kmeans = KMeansClusterer.run @kappa, data, labels: labels, runs: 5, scale_data: true

            kmeans.clusters.each do |cluster|
            puts  cluster.id.to_s + '. ' +
                    cluster.points.map(&:label).join(", ") + "\t" +
                    cluster.centroid.to_s
            end

#            # Use existing clusters for prediction with new data:
#            predicted = kmeans.predict [[41.85,-87.65]] # Chicago
#            puts "\nClosest cluster to Chicago: #{predicted[0]}"

            # Clustering quality score. Value between -1.0..1.0 (1.0 is best)
            puts "\nSilhouette score: #{kmeans.silhouette.round(2)}"
            kmeans.clusters
        end

    end
end
