class MessengerBotController < ActionController::Base
  def message(event, sender)
    # profile = sender.get_profile(field) # default field [:locale, :timezone, :gender, :first_name, :last_name, :profile_pic]
  profile = sender.get_profile[:body]
  profile_last_name = profile['last_name']
  profile_first_name = profile['first_name']
  text = event['message']['text']
# sender.reply({ text: "こんにちは。"})
  sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"#{profile_last_name} #{profile_first_name}さんこんにちは。あなたの曲探しをお手伝いします",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"曲を探す",
                        "payload":"lookformusic"
                    },
                    {
                        "type":"postback",
                        "title":"説明を読む。",
                        "payload":"readinstructions"
                    }
                ]
            }
          }
      })
      
      if text == お気に入り or おきにいり
          sender.reply({ text: "お気に入り一覧"})
      elsif text == おすすめ or オススメ or お薦め
          sender.reply({ text: "オススメの一曲はこちらです。"})
      else
          sender.reply({ text: "すみません、私には分からないのです。"})
      end
          
    # sender.reply({ text: "Reply: #{event['message']['text']}" })
  end

  def delivery(event, sender)
  end

  def postback(event, sender)
    profile = sender.get_profile[:body]
    profile_last_name = profile['last_name']
    profile_first_name = profile['first_name']
    payload = event["postback"]["payload"]
    case payload
    #テンポ絞り込み
    when "lookformusic"
        sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"#{profile_last_name} #{profile_first_name}さんは今どんな気分ですか？",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"ノリノリで行きたい",
                        "payload":"hightempo"
                    },
                    {
                        "type":"postback",
                        "title":"リラックスしたい",
                        "payload":"lowtempo"
                    },
                    # {
                    #     "type":"postback",
                    #     "title":"どちらでもない",
                    #     "payload":"freeword"
                    # }
                ]
            }
        }
      })
      #ジャンルを絞り込む
      when "hightempo"
          sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"ノリノリといえばこんな感じでしょうか？",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"クラブで踊りたい",
                        "payload":"clubmusic"
                        
                    },
                    {
                        "type":"postback",
                        "title":"リオのカーニバルに行きたい",
                        "payload":"brazil"
                    }
                ]
            }
          }
      })
      
      when "lowtempo"
          sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"リラックスといえばこんな感じでしょうか？",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"地中海のリゾートでのんびりしたい",
                        "payload":"bossanova"
                        
                    },
                    {
                        "type":"postback",
                        "title":"ホテルの最上階のラウンジでお酒を飲みたい",
                        "payload":"jazz"
                    }
                ]
            }
          }
      })
      #曲を紹介する
      when "clubmusic"
          @music = Music.find_by(genre: "clubmusic")
          
          sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"#{@music.artist}の#{@music.musicname}はいかがでしょうか？",
                "buttons":[
                    {
                        "type":"web_url",
                        "url":"#{@music.url}",
                        "title":"曲を聴く。"
                        
                    },
                    {
                        "type":"postback",
                        "title":"お気に入りに登録する。",
                        "payload":"favorite"
                    }
                ]
            }
          }
      })
      when "brazil"
          sender.reply({ text: "サンバ" })
      when "bossanova"
          sender.reply({ text: "ボサノバ"})
      when "jazz"
          sender.reply({ text: "ジャズ" })
      
      #説明をする
      when "readinstructions"
          sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"私はあなたの気分に沿った曲を紹介するボットです。紹介した曲は、実際に聴いたり、お気に入りに登録できます。お気に入りをチェックしたいときは「お気に入り」と言ってみてください。「おすすめ」と言っていただければ、その日のおすすめをご紹介します。",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"さっそく曲を探す",
                        "payload":"lookformusic"
                    }
                ]
            }
        }
      })
        
        
      #ex) process sender.reply({text: "button click event!"})
    end
  end
end