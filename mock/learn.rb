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
    @right_score-@wrong_score
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
    "bride": 0.6788421273231506,
    "groom": 0.5829989314079285,
    "bridesmaids": 0.3676793575286865,
    "food": 0.10219500958919525,
    "wedding party": 0.34927165508270264,
    "reception": 0.4632208049297333,
    "ceremony": 0.38657301664352417,
    "vows": 0.33024221658706665,
    "kiss": 0.3947228789329529,
    "fashion": 0.6435966491699219,
    "jewelry": 0.1828344464302063,
    "rings": 0.09682630747556686,
    "invitations": 0.10170792043209076,
    "bedroom": 0.06894209235906601,
    "flowers": 0.7534128427505493,
    "bouquet": 0.27867794036865234,
    "getting ready": 0.26363810896873474,
    "ring bearer": 0.07279980927705765,
    "table": 0.07523700594902039,
    "decor": 0.3303520083427429,
    "photo": "fourseasons_toronto_wedding_purple_tree-99.jpg",
    "type": nil
  }

$learn_n1 = Node.new(1, get_data_set)
$learn_n2 = Node.new(2, get_data_set)
$learn_n3 = Node.new(3, get_data_set)
$learn_n4 = Node.new(4, get_data_set)
$learn_n5 = Node.new(5, get_data_set)
$learn_n6 = Node.new(6, get_data_set)
$learn_n7 = Node.new(7, get_data_set)
puts n1.classify(custom_data)
puts n2.classify(custom_data)
puts n3.classify(custom_data)
puts n4.classify(custom_data)
puts n5.classify(custom_data)
puts n6.classify(custom_data)
puts n7.classify(custom_data)