require 'matrix'
require 'matrix/eigenvalue_decomposition'


module ClusteringModule
  class SpectralClusteringAlgorithm
    def initialize(similarity_matrix)
      @similarity_matrix = similarity_matrix
    end

    def run(kappa = 5)
      # v---- This is a "splat" operator
      # p "sdafdsfsdafsdafsdklafnkdsaflksadnfklsnklfnsdl"


      # p "@similarity_matrix= #{@similarity_matrix}"

      degree_matrix = Matrix.diagonal *@similarity_matrix.row_vectors.map{|v| v.sum}

      # p "degree_matrix= #{degree_matrix}"

      unnormalized_laplacian = degree_matrix - @similarity_matrix

      # p "unnormalized_laplacian= #{unnormalized_laplacian}"

      decomposition = Matrix::EigenvalueDecomposition.new(unnormalized_laplacian)

      # p "decomposition= #{decomposition}"

      u = Matrix.columns(decomposition.eigenvectors.take(kappa))

      # p "u= #{u}"

      y = u.row_vectors

      # p "y= #{y}"

      # puts decomposition.eigenvalues.take(kappa).join(",\n")
      # puts decomposition.eigenvectors.take(kappa).join(",\n")
      # puts u

      # puts y.join(",\n")

      # Use uniq to prevent duplicate vectors
      # clusters = y.uniq{|v| v.map{|j| j.round(0)}}.sample(kappa).map{|v| [y.index(v)]}
      #
      clusters = y.sample(kappa).map{|v| [y.index(v)]}
      # p "clusters= #{clusters}"

      centroids = clusters.map{ |cl| get_centroid(cl, y, y[0] - y[0]) }

      # p "centroids= #{centroids}"

      loop do
        # puts "clusters: #{clusters}"
        #  stats(clusters)

        # puts "centroids: #{centroids}"
        old_centroids = Array.new(centroids)
        clusters = []
        y.each_with_index do |y_i, i|
          # p "node i = #{i}"
          closest = find_closest(y_i, centroids)
          # p "The closest is #{closest}"
          clusters[closest] ||= []
          clusters[closest].push i
        end

        # p "New clusters: #{clusters}"
        centroids = clusters.map.with_index { |cl, i| get_centroid(cl, y, old_centroids[i]) }
        # puts "New centroids: #{centroids}"
        break if (centroids <=> old_centroids) == 0
      end

      # p "The clusters are #{clusters}"
      clusters
    end

    private

    def get_centroid(cluster, y, old_centroid)
      s = nil
      cluster.each do |i|
        # p "i= #{i}"
        #  p "y[i]= #{y[i]}"
        s = s.nil? ? y[i] : y[i]+ s
        # p "s= #{s}"
      end

      # p "length: #{cluster.length}"
      s / cluster.length
    end

    def find_closest(vector, centroids)
      res = centroids.index(centroids.min_by {|c| (c - vector).magnitude })
      # p "RESULT #{res}"
      res
    end

  end

end
