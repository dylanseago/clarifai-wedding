require_relative 'dataset'


dataset = get_data_set

$base_data = {}

dataset.each do |data|
  data.each do |k,v|
    next if k == :photo || k == :type
    $base_data[k] ||= 0
    $base_data[k] += v.to_f
  end
end

$base_data.each do |k,v|
  $base_data[k] = v.to_f/(dataset.length)
end



class Filter
  def initialize(type, tag, dataset)
    @type = type
    @tag = tag
    @right_set = []
    @wrong_set = []
    @right_score = 0
    @wrong_score = 0
    @score_multiplier = 1.2
    @dataset = dataset
    base_set = []

    #iterate over all of our data
    @dataset.each do |data|
      if data[:type] == @type
        if data[tag] > $base_data[tag]
          @right_set << data
          @right_score += (data[tag] - $base_data[tag]).abs*@score_multiplier
        else
          @wrong_set << data
          @wrong_score += (data[tag] - $base_data[tag]).abs
        end
      end
    end
  end

  def get_tag
    @tag
  end

  def get_right_set
    @right_set
  end

  def get_wrong_set
    @wrong_set
  end

  def get_score
    rs = @right_set.length
    rs = 1 if rs == 0
    ws = @wrong_set.length
    ws = 1 if ws == 0
    @right_score/rs-@wrong_score/ws
  end
end



class MachNode
  def initialize(type, dataset)
    @type = type
    @dataset = dataset
    @filter = best_filter

    if ((Math.log(@filter.get_right_set.length.to_f+1,2)/(@filter.get_right_set.length+@filter.get_wrong_set.length)) >= 0.5) || @filter.get_wrong_set.length == 0
      @right = nil
      @left = nil
    else
      @right = MachNode.new(@type, @filter.get_right_set)
      @left = MachNode.new(@type, @filter.get_wrong_set)
    end
  end

  def best_filter
    best_filter = nil
    best_score = -1
    $base_data.keys.each do |tag|
      f = Filter.new(@type, tag, @dataset)
      score = f.get_score

      if score > best_score
        best_filter = f
        best_score = score
      end
    end
    best_filter
  end

  def classify(data, current = false)
    return current if (@left == nil || @right == nil)

    if(data[@filter.get_tag].to_f > $base_data[@filter.get_tag].to_f)
      @right.classify(data, true)
    else
      @left.classify(data, false)
    end
  end
end

$learn_n1 = MachNode.new(1, get_data_set)
$learn_n2 = MachNode.new(2, get_data_set)
$learn_n3 = MachNode.new(3, get_data_set)
$learn_n4 = MachNode.new(4, get_data_set)
$learn_n5 = MachNode.new(5, get_data_set)
$learn_n6 = MachNode.new(6, get_data_set)
$learn_n7 = MachNode.new(7, get_data_set)

puts "Finished Training"