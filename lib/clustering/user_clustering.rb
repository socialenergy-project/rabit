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
                    UserClustering.parameterTypes[v.to_sym][:callback].call(u)
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
                game_score: {
                    callback: ->(u) {
                        GameActivity.get_current_score(u)
                    },
                    group: :game,
                    header: :score,
                },
                game_activity: {
                    callback: ->(u) {
                        GameActivity.get_total_time_played(u)
                    },
                    group: :game,
                    header: :activity,
                },
                game_credits: {
                    callback: ->(u) {
                        GameReward.get_current_gredits(u)
                    },
                    group: :game,
                    header: :rewards,
                },
                game_cash: {
                    callback: ->(u) {
                        GameReward.get_cash(u)
                    },
                    group: :game,
                    header: :rewards,
                },
                game_ex_points: {
                    callback: ->(u) {
                        GameReward.get_ex_points(u)
                    },
                    group: :game,
                    header: :rewards,
                },
                lcms_score: {
                    callback: ->(u) {
                        LcmsScore.get_current_score(u)
                    },
                    group: :lcms,
                    header: :score,
                },
                lcms_last_week_score: {
                    callback: ->(u) {
                        LcmsScore.get_last_week_score(u)
                    },
                    group: :lcms,
                    header: :score,
                },
                lcms_last_month_score: {
                    callback: ->(u) {
                        LcmsScore.get_last_month_score(u)
                    },
                    group: :lcms,
                    header: :score,
                },
                lcms_score_competence_1: {
                    callback: ->(u) {
                        LcmsScore.get_current_score_competence(u, 1)
                    },
                    group: :lcms,
                    header: :score,
                },
                lcms_score_competence_2: {
                    callback: ->(u) {
                        LcmsScore.get_current_score_competence(u, 2)
                    },
                    group: :lcms,
                    header: :score,
                },
                lcms_score_competence_3: {
                    callback: ->(u) {
                        LcmsScore.get_current_score_competence(u, 3)
                    },
                    group: :lcms,
                    header: :score,
                },
                lcms_score_competence_4: {
                    callback: ->(u) {
                        LcmsScore.get_current_score_competence(u, 4)
                    },
                    group: :lcms,
                    header: :score,
                },
                lcms_score_competence_5: {
                    callback: ->(u) {
                        LcmsScore.get_current_score_competence(u, 5)
                    },
                    group: :lcms,
                    header: :score,
                },
                lcms_score_competence_6: {
                    callback: ->(u) {
                        LcmsScore.get_current_score_competence(u, 6)
                    },
                    group: :lcms,
                    header: :score,
                },
                lcms_score_competence_7: {
                    callback: ->(u) {
                        LcmsScore.get_current_score_competence(u, 7)
                    },
                    group: :lcms,
                    header: :score,
                },
                lcms_level_competence_1: {
                    callback: ->(u) {
                        LcmsBadge.get_level(u, "Energy efficient electric appliances")
                    },
                    group: :lcms,
                    header: :reward,
                },
                lcms_level_competence_2: {
                    callback: ->(u) {
                        LcmsBadge.get_level(u, "EU Energy Labelling")
                    },
                    group: :lcms,
                    header: :reward,
                },
                lcms_level_competence_3: {
                    callback: ->(u) {
                        LcmsBadge.get_level(u, "Energy Metrics")
                    },
                    group: :lcms,
                    header: :reward,
                },
                lcms_level_competence_4: {
                    callback: ->(u) {
                        LcmsBadge.get_level(u, "Demand Response")
                    },
                    group: :lcms,
                    header: :reward,
                },
                lcms_level_competence_5: {
                    callback: ->(u) {
                        LcmsBadge.get_level(u, "Smart Grid")
                    },
                    group: :lcms,
                    header: :reward,
                },
                lcms_level_competence_6: {
                    callback: ->(u) {
                        LcmsBadge.get_level(u, "Pricing Schemes")
                    },
                    group: :lcms,
                    header: :reward,
                },
                lcms_level_competence_7: {
                    callback: ->(u) {
                        LcmsBadge.get_level(u, "Energy Communities")
                    },
                    group: :lcms,
                    header: :reward,
                },
                lcms_badge_count: {
                    callback: ->(u) {
                        LcmsBadge.where(user_id: u).count
                    },
                    group: :lcms,
                    header: :activity,
                },
                lcms_activity: {
                    callback: ->(u) {
                        LcmsCourse.get_total_time_played(u)
                    },
                    group: :lcms,
                    header: :activity,
                },
            }
        end

    end
end
