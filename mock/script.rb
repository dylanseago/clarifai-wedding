require 'curb'
require'json'


tracker = []

(0..6).each do |i|
    tracker[i] = []
end

Dir.foreach(Dir.pwd+'/2') do |photo_file|
    next if photo_file.to_s.length < 10
    c = Curl::Easy.new("https://api.clarifai.com/v1/tag/") do |curl|
      curl.headers['Authorization'] = 'Bearer p6W95YdN4xXHRm2Wt7QCKipuPHEnhf'
    end
    c.multipart_form_post = true


    c.http_post(Curl::PostField.content('model', 'weddings-v1.0'),
                Curl::PostField.file('encoded_data', '2/'+photo_file.to_s))


    parsed_tags = JSON.parse(c.body_str)['results'][0]['result']['tag']
    tag_list = {}
    parsed_tags['classes'].each_with_index do |tag, i|
      tag_list[tag] = parsed_tags['probs'][i]
    end
    puts photo_file
    puts JSON.pretty_generate(tag_list)
    puts "\n"

    #choice = gets

    #tracker[choice] << tag_list



    puts "\n\n\n"

end


#tracker.each do |num|
#    tracker[num][x][y]

#end
