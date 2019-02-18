require 'test_helper'
require 'clustering/user_clustering.rb'
require 'webmock/test_unit'


class UserClusteringTest < ActionDispatch::IntegrationTest
    setup do
        WebMock.stub_request(:post, "https://socialenergy.intelen.com/index.php/webservices/activitylcmsgame")
               .to_return(body: File.new('./test/fixtures/sample_user_data.txt'), status: 200)

        @uc = ClusteringModule::UserClustering.new
    end

    test "clustering simple should work" do
        assert_equal(5, @uc.cluster_simple(User.where('uid IS NOT NULL')).count, "We should create 5 clusters")
    end
end
