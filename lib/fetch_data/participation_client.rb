module FetchData

  class ParticipationClient

    def initialize
      @gsrn_participation_url = "https://socialenergy.intelen.com/index.php/webservices/activitylcmsgame"
    end

    def get_stats(user = nil)
      result = RestClient.post @gsrn_participation_url , {
        username: user
      }

      Rails.logger.debug "The result is #{result}"

      json = JSON.parse result

      user_hash = {}

      if json['returnobjectGameActivity']&.size > 0
        GameActivity.bulk_insert ignore: true, values: (json['returnobjectGameActivity'].map do |r|
          user_hash[r['username']] ||= User.find_by(provider: 'Gsrn', uid: r['username'])&.id
          {
              totalScore: r['totalScore']&.to_i,
              user_id: user_hash[r['username']],
              dailyScore: r['dailyScore']&.to_i,
              gameDuration: r['gameDuration']&.to_i,
              timestampUserLoggediIn: Time.at(r['timestampUserLoggediIn'].to_i)&.to_datetime,
              energyProgram: r['energyProgram'],
              levelGame: r['levelGame'],
          }
        end.reject {|r| r[:user_id].nil?})
      end


      if json['returnobjectLcmsBadges']&.size > 0
        LcmsBadge.bulk_insert ignore: true, values: (json['returnobjectLcmsBadges'].map do |r|
          user_hash[r['username']] ||= User.find_by(provider: 'Gsrn', uid: r['username'])&.id
          split_name = r['BadgeName']&.split('-')
          if split_name&.size == 2
            {

              topic: split_name[0]&.strip,
              level: split_name[1]&.split('(')[0]&.strip,
              numeric: r['BadgeName']&.scan(/[\d.]+/)&.last&.to_f,
              user_id: user_hash[r['username']],
              date_given: r['DateGiven']&.to_date,
            }
          else
            {}
          end
        end.reject {|r| r[:user_id].nil?})
      end

      if json['returnobjectLcmsCourses']&.size > 0
        LcmsCourse.bulk_insert ignore: true, values: (json['returnobjectLcmsCourses'].map do |r|
          user_hash[r['username']] ||= User.find_by(provider: 'Gsrn', uid: r['username'])&.id
          split_name = r['CourseName']&.split('-')
          if split_name&.size == 2
            {

              topic: split_name[0]&.strip,
              level: split_name[1]&.split('(')[0]&.strip,
              numeric: r['BadgeName']&.scan(/[\d.]+/)&.last&.to_f,
              user_id: user_hash[r['username']],
              date_given: r['DateGiven']&.to_date,
            }
          else
            {}
          end
        end.reject {|r| r[:user_id].nil?})
      end










      :user_id, :topic, :level, :numeric, :graded_at,
                              :current_grade, :time_spent_seconds, :grade_min,
                              :grade_max,  :grade_pass


=begin
      if (JSON.parse(result)["status"] == "Recommendation added successfully." rescue false)
        message.update_attributes gsrn_status: :posted
      else
        message.update_attributes gsrn_status: :failed
      end
=end
      json
    end

  end

end
