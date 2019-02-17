module FetchData

  class ParticipationClient

    def initialize
      @gsrn_participation_url = "https://socialenergy.intelen.com/index.php/webservices/activitylcmsgame"
    end

    def get_stats(user = nil)
      result = RestClient.post @gsrn_participation_url, {
          username: user
      }, timeout: 10

      # Rails.logger.debug "The result is #{result}"

      json = JSON.parse result

      if json['returnobjectGameActivity']&.size > 0
        GameActivity.bulk_insert ignore: true, values: (json['returnobjectGameActivity'].map do |r|
          {
              totalScore: r['totalScore']&.to_i,
              user_id: get_user(r['username']),
              dailyScore: r['dailyScore']&.to_i,
              gameDuration: r['gameDuration']&.to_i,
              timestampUserLoggediIn: Time.at(r['timestampUserLoggediIn'].to_i)&.to_datetime,
              energyProgram: r['energyProgram'],
              levelGame: r['levelGame'],
          }
        end.reject {|r| r[:user_id].blank?})
      end


      if json['returnobjectLcmsBadges']&.size > 0
        LcmsBadge.bulk_insert ignore: true, values: (json['returnobjectLcmsBadges'].map do |r|
          {
              user_id: get_user(r['username']),
              date_given: r['DateGiven']&.to_date,
          }.merge(extract_topic_level_numeric(r['BadgeName']))
        end.reject {|r| r[:user_id].blank? || r[:topic].nil?})
      end

      if json['returnobjectLcmsCourses']&.size > 0
        LcmsCourse.bulk_insert ignore: true, values: (json['returnobjectLcmsCourses'].map do |r|
          {
              user_id: get_user(r['username']),
              graded_at: get_graded_at(r['DateGraded']),
              current_grade: r['CurrentGrade']&.to_f,
              time_spent_seconds: get_time_spent_seconds(r['TimeSpent']),
              grade_min: r['Grademin']&.to_f,
              grade_max: r['Grademax']&.to_f,
              grade_pass: r['Grademass']&.to_f,
          }.merge(extract_topic_level_numeric(r['CourseName']))
        end.reject {|r| r[:user_id].blank? || r[:topic].nil? || r[:graded_at].nil?})
      end

      if json['returnobjectLcmsScore']&.size > 0
        LcmsScore.bulk_insert ignore: true, values: (json['returnobjectLcmsScore'].each_with_object({}) do |r,h|
          if r['username']
            user = get_user(r['username'])
            h[user] ||= {}
            competence = r['Name'].scan(/\d+/)&.last&.to_i
            h[user][competence] ||= {}
            h[user][competence][
              case r['Name']
              when / total score$/
                :current_score
              when /^Last week's total score for competence /
                :last_week_score
              when /^Last month's total score for competence /
                :last_month_score            
              end
            ] = r['Value'].to_f
          end
        end.to_a.map  do |user,v1|
          v1.to_a.map do |comp,v|
            v.merge competence: comp
          end.map do |v|
            v.merge user_id: user
          end
        end.flatten.reject{|r| r[:user_id].blank?})
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

    private

    def get_user(username)
      return if  username.blank? || username == "0"
      @user_hash ||= {}
      uuid = SecureRandom.uuid
      @user_hash[username] ||= User.create_with(email: "#{SecureRandom.uuid}@test.com",
                                                password: uuid, password_confirmation: uuid)
                                   .find_or_create_by(provider: 'Gsrn', uid: username)&.id

    end

    def get_graded_at(date_graded)
      date_graded&.to_datetime
    rescue
      Time.at(date_graded&.to_i)
    end

    def get_time_spent_seconds(time)
      (Time.parse("00:" + time) - Time.parse('00:00'))
    rescue
      nil
    end

    def extract_topic_level_numeric(description)
      split_name = description&.split('-')
      if split_name&.size == 2
        {
            topic: split_name[0]&.strip&.split("Level")[0]&.strip&.remove('.'),
            level: split_name[1]&.split('(')[0]&.strip,
            numeric: description&.scan(/[\d.]+/)&.last&.to_f,
        }
      else
        {}
      end
    end

  end

end
