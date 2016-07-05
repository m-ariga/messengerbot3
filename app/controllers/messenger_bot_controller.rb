class MessengerBotController < ActionController::Base
    @@debug_mode = false
    def message(event, sender)
    # profile = sender.get_profile(field) # default field [:locale, :timezone, :gender, :first_name, :last_name, :profile_pic]
        profile = sender.get_profile[:body]
        profile_last_name = profile['last_name']
        profile_first_name = profile['first_name']
        text = event['message']['text']
        sender_id = event['sender']['id']
    # sender.reply({ text: "こんにちは。"})
        begin
            @user = User.find_by(sender_id: sender_id)
        
            if @user.nil?
            @user = User.create(sender_id: sender_id)
            end
        
            if @@debug_mode
            sender.reply({text: "あなたのIDは#{@user.id}"})
            sender.reply({text: "あなたのsenderIDは#{@user.sender_id}"})   
            end
        rescue => error_res
            if @@debug_mode
            sender.reply({text: "エラー：#{error_res.message}"})
            end
        end
        
        if text == "お気に入り"
          @favorites = Array.new
          @favorites = @user.favorites.where(user_id: @user.id)
          t = @favorites.count - 1
          0.upto(t){|s|
          sender.reply({ "attachment":{
                            "type":"template",
                            "payload":{
                                "template_type":"button",
                                "text":"#{s + 1}. 曲名：#{@favorites[s].musicname} \n アーティスト：#{@favorites[s].artist}",
                                "buttons":[
                                    {
                                        "type":"web_url",
                                        "url":"#{@favorites[s].url}",
                                        "title":"聞く",
                                        
                                    }
                                    # {
                                    #     "type":"postback",
                                    #     "title":"お気に入りから外す",
                                    #     "payload":"delete"
                                    # }
                                ]
                            }
                          }
                      })
          
        #   sender.reply({ text: "#{s + 1}. 曲名：#{@favorites[s].musicname}、アーティスト：#{@favorites[s].artist}、URL：#{@favorites[s].url}" })
          }
        elsif text == "おすすめ"
          sender.reply({ text: "おすすめを教えちゃうよ！"})
        elsif text == "こんにちは"
          sender.reply({ "attachment":{
                            "type":"template",
                            "payload":{
                                "template_type":"button",
                                "text":"#{profile_last_name} #{profile_first_name}さん、こんにちは〜",
                                "buttons":[
                                    {
                                        "type":"postback",
                                        "title":"曲を探す",
                                        "payload":"lookformusic"
                                    },
                                    {
                                        "type":"postback",
                                        "title":"説明を読む",
                                        "payload":"readinstructions"
                                    },
                                ]
                            }
                          }
                      })
            
        else
        end 
        
    end    
    
          
    # sender.reply({ text: "Reply: #{event['message']['text']}" })
    def delivery(event, sender)
    end

  def postback(event, sender)
    profile = sender.get_profile[:body]
    profile_last_name = profile['last_name']
    profile_first_name = profile['first_name']
    payload = event["postback"]["payload"]
    sender_id = event['sender']['id']
    
    begin
        @user = User.find_by(sender_id: sender_id)
        
        if @user.nil?
            @user = User.create(sender_id: sender_id)
        end
        
        if @@debug_mode
            sender.reply({text: "あなたのIDは#{@user.id}"})
            sender.reply({text: "あなたのsenderIDは#{@user.sender_id}"})   
        end
    rescue => error_res
        if @@debug_mode
            sender.reply({text: "エラー：#{error_res.message}"})
        end
    end
        
    case payload
    #テンポ絞り込み
    when "lookformusic"
        sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"#{profile_first_name}、How are you feeling? いまどんな気分〜？",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"ノリノリで行きたい。Yeah!",
                        "payload":"hightempo"
                    },
                    {
                        "type":"postback",
                        "title":"リラックスしたい",
                        "payload":"lowtempo"
                    },
                    {
                        "type":"postback",
                        "title":"どちらでもない",
                        "payload":"freeword"
                    }
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
                "text":"ノリノリって言ったらこんな感じ？",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"クラブで踊りたい",
                        "payload":"clubmusic"
                        
                    },
                    {
                        "type":"postback",
                        "title":"湘南の海でサーフィンがしたい",
                        "payload":"shonan"
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
           @@music = Music.find_by(genre: "clubmusic")
          
           sender.reply({ "attachment":{
             "type":"template",
             "payload":{
                 "template_type":"button",
                 "text":"#{@@music.artist}の#{@@music.musicname}はいかがでしょうか？",
                 "buttons":[
                     {
                         "type":"web_url",
                         "url":"#{@@music.url}",
                         "title":"聴いてみる！"
                        
                     },
                     {
                         "type":"postback",
                         "title":"気に入った！",
                         "payload":"favorite"
                     },
                     {
                         "type":"postback",
                         "title":"もう一度",
                         "payload":"lookformusic"
                     }
                 ]
             }
           }
       })
      when "shonan"
          @@music = Music.find_by(genre: "surfrock")
          sender.reply({ "attachment":{
             "type":"template",
             "payload":{
                 "template_type":"button",
                 "text":"#{@@music.artist}の#{@@music.musicname}はいかがでしょうか？",
                 "buttons":[
                     {
                         "type":"web_url",
                         "url":"#{@@music.url}",
                         "title":"聴いてみる！"
                        
                     },
                     {
                         "type":"postback",
                         "title":"気に入った！",
                         "payload":"favorite"
                     },
                     {
                         "type":"postback",
                         "title":"もう一度",
                         "payload":"lookformusic"
                     }
                 ]
             }
           }
       })
      when "bossanova"
          @@music = Music.find_by(genre: "bossanova")
          sender.reply({ "attachment":{
             "type":"template",
             "payload":{
                 "template_type":"button",
                 "text":"#{@@music.artist}の#{@@music.musicname}はいかがでしょうか？",
                 "buttons":[
                     {
                         "type":"web_url",
                         "url":"#{@@music.url}",
                         "title":"聴いてみる！"
                        
                     },
                     {
                         "type":"postback",
                         "title":"気に入った！",
                         "payload":"favorite"
                     },
                     {
                         "type":"postback",
                         "title":"もう一度",
                         "payload":"lookformusic"
                     }
                 ]
             }
           }
       })
      when "jazz"
          @@music = Music.find_by(genre: "jazz")
          
           sender.reply({ "attachment":{
             "type":"template",
             "payload":{
                 "template_type":"button",
                 "text":"#{@@music.artist}の#{@@music.musicname}はいかがでしょうか？",
                 "buttons":[
                     {
                         "type":"web_url",
                         "url":"#{@@music.url}",
                         "title":"聴いてみる！"
                        
                     },
                     {
                         "type":"postback",
                         "title":"気に入った！",
                         "payload":"favorite"
                     },
                     {
                         "type":"postback",
                         "title":"もう一度",
                         "payload":"lookformusic"
                     }
                 ]
             }
           }
       })
        #   sender.reply({ text: "ジャズ" })
      
      #説明をする
      when "readinstructions"
          sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"あなたの気分に合いそうな曲を教えるよ。\nいい！と思ったら、お気に入りに登録してね。\n「お気に入り」と言ってくれたらいつでもお気に入りに登録した曲が見られるよ。\n「おすすめ」と言ってくれたら、僕のお気に入りを教えちゃうよ！\n気が向いた時に話しかけてくれたら嬉しいなあ",
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
        #お気に入り機能
        when "favorite"
            @favorite = @user.favorites.create(artist: @@music.artist, musicname: @@music.musicname, genre: @@music.genre, url: @@music.url)
            sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"お気に入りに登録しました",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"お気に入りを見る",
                        "payload":"showfavorite"
                    }
                ]
            }
        }
      })
      
      when "showfavorite"
        @favorites = Array.new
        @favorites = @user.favorites.where(user_id: @user.id)
        t = @favorites.count - 1
        0.upto(t){|s|
          sender.reply({ "attachment":{
                            "type":"template",
                            "payload":{
                                "template_type":"button",
                                "text":"#{s + 1}. 曲名：#{@favorites[s].musicname} \n アーティスト：#{@favorites[s].artist}",
                                "buttons":[
                                    {
                                        "type":"web_url",
                                        "url":"#{@favorites[s].url}",
                                        "title":"聞く",
                                        
                                    }
                                    
                                ]
                            }
                          }
                      })
                    }  
            
            begin
                if @@debug_mode
                    sender.reply({text: "追加するユーザは：#{@user.sender_id}"})
                    sender.reply({text: "table insert"})
                end
                # sender.reply({text: "お気に入りに登録しました。"})       
            rescue => error_res
                if @@debug_mode
                    sender.reply({text: "エラー：#{error_res.message}"})
                end
            end
            

            
            
        
      #ex) process sender.reply({text: "button click event!"})
        
        # when "delete"
        # @@favorite = @@user.favorites.find_by(:id)
        # @@favorite.destroy
        # sender.reply({text: "お気に入りから外しました。"})
    end
  end
  
  
end