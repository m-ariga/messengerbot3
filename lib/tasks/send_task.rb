task :send_task => :environment do
system(curl -X POST -H "Content-Type: application/json" -d '{
  "recipient":{
    "id":"1080636225362452"
  },
  "message":{
    "attachment":{
      "type":"template",
      "payload":{
        "template_type":"button",
        "text":"そろそろ眠いですか？この曲を聴けば少しは眼が覚めるかも？",
        "buttons":[
          {
            "type":"web_url",
            "url":"http://www.last.fm/music/Led+Zeppelin/_/Immigrant+Song",
            "title":"聴く"
          },
          {
            "type":"postback",
            "title":"お気に入り",
            "payload":"showfavorite"
          }
        ]
      }
    }
  }
}' "https://graph.facebook.com/v2.6/me/messages?access_token=EAAOsKn9vHH0BANcZCGPpSIbiL93pJkE5v5A6jjneIDkeY5WEIko0ngu6h20U5GcEu2tfbjbQI130J5x63FbZCSkUTqZB02lznYclJsTKEoDwvJfyyZAxdiE6CNziBvW1ZBffqzH5lqk5V3R2PFlAmbIE5ED27GfRkGArYurCnZAAZDZD")
end