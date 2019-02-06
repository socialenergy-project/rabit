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

      if json['returnobjectGameActivity']&.size > 0
        user_hash = {}
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
