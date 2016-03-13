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
  $base_data[k] = v.to_f/(dataset.length*1.1)
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


class Node
  def initialize(type, dataset)
    @type = type
    @dataset = dataset
    @filter = best_filter

    if ((Math.log(@filter.get_right_set.length.to_f+1,2)/(@filter.get_right_set.length+@filter.get_wrong_set.length)) >= 0.5) || @filter.get_wrong_set.length == 0
      @right = nil
      @left = nil
    else
      @right = Node.new(@type, @filter.get_right_set)
      @left = Node.new(@type, @filter.get_wrong_set)
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

#f = Filter.new(2,:bride,get_data_set)
#puts f.get_right_set

custom_data =    {
    "bride": 0.8767462968826294,
    "groom": 0.5991272926330566,
    "bridesmaids": 0.41437000036239624,
    "food": 0.02514313906431198,
    "wedding party": 0.30663439631462097,
    "reception": 0.25687259435653687,
    "ceremony": 0.22856847941875458,
    "vows": 0.23676002025604248,
    "kiss": 0.23783639073371887,
    "fashion": 0.8473168611526489,
    "jewelry": 0.41319549083709717,
    "rings": 0.17846491932868958,
    "invitations": 0.07687154412269592,
    "bedroom": 0.06311151385307312,
    "flowers": 0.2960810363292694,
    "bouquet": 0.12385012209415436,
    "getting ready": 0.4509758949279785,
    "ring bearer": 0.07602142542600632,
    "table": 0.026845846325159073,
    "decor": 0.052610985934734344,
    "photo": "fourseasons_toronto_wedding_purple_tree-98.jpg",
    "type": 2
  }

$learn_n1 = Node.new(1, get_data_set)
$learn_n2 = Node.new(2, get_data_set)
$learn_n3 = Node.new(3, get_data_set)
$learn_n4 = Node.new(4, get_data_set)
$learn_n5 = Node.new(5, get_data_set)
$learn_n6 = Node.new(6, get_data_set)
$learn_n7 = Node.new(7, get_data_set)

(0..100).each do 
  puts $learn_n1.classify(custom_data)
  puts $learn_n2.classify(custom_data)
  puts $learn_n3.classify(custom_data)
  puts $learn_n4.classify(custom_data)
  puts $learn_n5.classify(custom_data)
  puts $learn_n6.classify(custom_data)
end
puts $learn_n7.classify(custom_data)