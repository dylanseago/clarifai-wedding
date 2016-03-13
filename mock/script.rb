require 'curb'
require'json'


full_tags = []
targ_dir = '3'


Dir.foreach(Dir.pwd+'/' + targ_dir) do |photo_file|
    puts photo_file
    next if photo_file.to_s.length < 10
    c = Curl::Easy.new("https://api.clarifai.com/v1/tag/") do |curl|
      curl.headers['Authorization'] = 'Bearer p6W95YdN4xXHRm2Wt7QCKipuPHEnhf'
    end
    c.multipart_form_post = true

    c.http_post(Curl::PostField.content('model', 'weddings-v1.0'),
                Curl::PostField.content('select_classes',"bride,groom,bridesmaids,food,wedding party,reception,ceremony,vows,groomsmen,fashion,jewelry,rings,invitations,bedroom,flowers,bouquet,getting ready,ring bearer,table,decor"),
                Curl::PostField.file('encoded_data', targ_dir+'/'+photo_file.to_s))

    parsed_tags = JSON.parse(c.body_str)['results'][0]['result']['tag']
    tag_list = {}
    parsed_tags['classes'].each_with_index do |tag, i|
      tag_list[tag] = parsed_tags['probs'][i]
    end

    puts photo_file
    tag_list['photo'] = photo_file
    tag_list['type'] = 0
    puts JSON.pretty_generate(tag_list)

    full_tags << tag_list


    puts "\n\n"
end

puts JSON.pretty_generate(full_tags)