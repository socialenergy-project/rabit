require 'open3'

class PythonWrapper

  def self.string_to_ep(string)
    EnergyProgram.find_by name: {
        "PRTP" => 'Personal Real-time pricing',
        "No-DR" => 'RTP (no DR)',
        "RTP" => 'Real-time pricing',
        "CRTP" => 'Community Real-time pricing'
    }[string]
  end

  def self.pre_process_input(input)
    input.map do |k,v|
      if k == :select_algorithm
        [k, v.map do |alg|
          {
              'Personal Real-time pricing' => 1,
              'RTP (no DR)' => 3,
              'Real-time pricing' => 2,
          }[alg.name]
        end]
      else
        [k,v]
      end
    end.to_h
  end

  def self.pre_process_input2(input)
    input.map do |k,v|
      if k == :select_algorithm
        [k, v.map do |alg|
          {
              'Personal Real-time pricing' => 1,
              'Real-time pricing' => 2,
              'Community Real-time pricing' => 3,
              'RTP (no DR)' => 4,
          }[alg.name]
        end]
      else
        [k,v]
      end
    end.to_h
  end

  def self.run_pricing(input, directory='pricing_algorithms')
    Dir.chdir(directory) do

      friendships = {
          "nodes_dictionary":[
              {
                  "11": ["9", "10", "4", "5", "15", "12", "16", "1"], "10": ["8", "9", "2", "3", "11", "12", "13", "1", "15"], "13": ["12", "14", "4", "5", "16", "10", "15", "1"], "12": ["10", "13", "14", "8", "7", "11", "15", "16"], "15": ["16", "14", "11", "12", "13", "10"], "14": ["12", "13", "16", "9", "4", "15", "1", "6", "3"], "16": ["13", "14", "15", "8", "9", "11", "12"], "1": ["2", "3", "5", "8", "10", "11", "13", "14", "4"], "3": ["10", "1", "2", "14"], "2": ["4", "10", "7", "8", "9", "1", "3"], "5": ["6", "7", "11", "13", "1"], "4": ["2", "11", "13", "14", "1"], "7": ["5", "6", "8", "12", "2", "9"], "6": ["5", "7", "8", "9", "14"], "9": ["6", "8", "10", "11", "14", "16", "2", "7"], "8": ["6", "7", "9", "10", "12", "16", "2", "1"]
              }
          ],
          "friendship_dictionary":[
              {
                  "7|12": [755], "12|8": [755], "13|4": [755], "13|5": [755], "12|7": [755], "2|10": [755], "4|14": [755], "9|10": [755], "9|11": [755], "9|14": [755], "9|16": [755], "3|1": [755], "10|9": [755], "10|8": [755], "4|13": [755], "4|11": [755], "13|1": [755], "10|3": [755], "10|2": [755], "10|1": [755], "8|7": [755], "7|6": [755], "14|9": [755], "14|6": [755], "3|14": [755], "14|4": [755], "14|3": [755], "3|10": [755], "1|3": [755], "14|13": [755], "14|12": [755], "14|16": [755], "14|15": [755], "8|12": [755], "8|10": [755], "8|16": [755], "5|1": [755], "5|6": [755], "5|7": [755], "3|2": [755], "7|8": [755], "7|9": [755], "9|6": [755], "9|7": [755], "11|9": [755], "9|2": [755], "7|2": [755], "11|1": [755], "7|5": [755], "11|4": [755], "11|5": [755], "1|10": [755], "1|11": [755], "1|13": [755], "1|14": [755], "8|9": [755], "11|10": [755], "8|6": [755], "11|12": [755], "11|15": [755], "11|16": [755], "15|14": [755], "15|16": [755], "15|10": [755], "15|11": [755], "15|12": [755], "15|13": [755], "16|15": [755], "16|14": [755], "16|11": [755], "16|13": [755], "16|12": [755], "9|8": [755], "1|8": [755], "1|4": [755], "1|5": [755], "1|2": [755], "5|11": [755], "5|13": [755], "2|9": [755], "2|8": [755], "2|4": [755], "2|7": [755], "2|1": [755], "2|3": [755], "4|2": [755], "4|1": [755], "14|1": [755], "13|12": [755], "13|10": [755], "13|16": [755], "13|14": [755], "13|15": [755], "6|9": [755], "6|8": [755], "6|5": [755], "6|7": [755], "12|11": [755], "12|10": [755], "12|13": [755], "12|15": [755], "12|14": [755], "12|16": [755], "16|9": [755], "16|8": [755], "8|2": [755], "8|1": [755], "10|15": [755], "10|13": [755], "10|12": [755], "10|11": [755], "6|14": [755]
              }
          ]
      }.to_json

      processed_input = directory == 'pricing_algorithms' ? self.pre_process_input(input) : self.pre_process_input2(input)

      Rails.logger.debug "The processed input is #{processed_input}"

      result, stderr, status = Open3.capture3("python energydata.py '#{processed_input.to_json}' '#{create_friendships(input).to_json}'")
      Rails.logger.debug stderr

      if status == 0
        Rails.logger.debug "Execution succesfull, OUTPUT: ````#{result}````"

        if directory == 'pricing_algorithms'
          JSON.parse(result).map do |k,v|
            [
                string_to_ep(k.split("-").first),
                k.split("-").second.to_i,
            ] + v
          end
        else
          p "The output was '#{result}'"
          JSON.parse(result).map{|k,v| [string_to_ep(k), v] }.to_h
        end


      else
        raise PythonError.new(stderr)
      end
    end
  rescue SystemCallError, JSON::JSONError => e
    Rails.logger.debug "Exception is #{e.class}"
    raise PythonError.new("#{e.class} " + JSON.pretty_unparse(e), "#{e.class} " + e.message.truncate(100, separator: /\s/))
  end

  private
  def self.create_friendships(input)
    n1 = input[:consumer_ids][0]
    {
        "nodes_dictionary":[
            input[:consumer_ids].map do |c|
              if c == n1
                [c, input[:consumer_ids].drop(1)]
              else
                [c, [n1]]
              end
            end.to_h
        ],
        "friendship_dictionary":[
            (input[:consumer_ids].drop(1).map do |c|
              [ "#{n1}|#{c}", [755] ]
            end + input[:consumer_ids].drop(1).map do |c|
              [ "#{c}|#{n1}", [755] ]
            end).to_h
        ]
    }
  end
end

class PythonError < StandardError
  attr_reader :stderr
  attr_reader :msg
  def initialize(stderr=nil, msg='Python algorithm returned non-zero exit code.')
    @stderr = stderr
    @msg = msg
    super(msg)
  end
end
