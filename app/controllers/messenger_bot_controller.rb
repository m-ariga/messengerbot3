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
          sender.reply({ text: "オススメの一曲はこちらです。"})
        elsif text == "こんにちは"
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
    
    # @user = User.find_by(sender_id: sender_id)
    # # if @user = User.find_by(sender_id: sender_id).nil?
    # #     @user = User.new(sender_id: sender_id)
    # #     @user.save
    # # end
        
    # sender.reply({text: "あなたのsenderIDは#{@user.sender_id}"})
        
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
                "text":"ノリノリといえばこんな感じでしょうか？",
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
        #   sender.reply({ text: "ジャズ" })
      
      #説明をする
      when "readinstructions"
          sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"私はあなたの気分に合った曲を紹介するボットです。紹介した曲は、実際に聴いたり、お気に入りに登録したりできます。お気に入りをチェックするには、「お気に入り」と言ってください。「おすすめ」と言っていただければ、その日のおすすめをご紹介します。",
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
            
            begin
                if @@debug_mode
                    sender.reply({text: "追加するユーザは：#{@user.sender_id}"})
                    sender.reply({text: "table insert"})
                end
                @favorite = @user.favorites.create(artist: @@music.artist, musicname: @@music.musicname, genre: @@music.genre, url: @@music.url)
                
                
                sender.reply({text: "お気に入りに登録しました。"})       
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