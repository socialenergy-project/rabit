module FetchData

  class GroupMembershipClient

    def initialize
      @gsrn_group_membership_url = "https://socialenergy.intelen.com/index.php/webservices/socialstatus"
    end

    def get_all()
      User.all.map do |user|
        if user.uid
          result = RestClient.post @gsrn_group_membership_url, {
            username: user.uid
          }, timeout: 10
          json = JSON.parse result
          p "the results is ", json
          json.each do |g|
            Group.find_or_create_by name: g['userGroups']
          end
          user.group_memberships = json.map do |g|
            # if user.uid == g['username']
              GroupMembership.new user: user,
                                  group: Group.find_by(name: g['userGroups']),
                                  role: GroupMembership.roles[g['roleUser'].downcase.gsub(/ /, '_')]
            # end
          end.reject(&:nil?)
          user.save
          json
        end
      end
    end
  end

end
