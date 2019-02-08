require 'test_helper'
require 'clustering/user_clustering.rb'

class UserClusteringTest < ActionDispatch::IntegrationTest
    setup do
        @uc = ClusteringModule::UserClustering.new
    end

    test "clustering simple should work" do
        p @uc.cluster_simple
    end
end
