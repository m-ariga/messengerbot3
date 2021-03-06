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
        elsif text == "説明"
        sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"あなたの気分に合いそうな曲を教えます。\nいい！と思ったら、お気に入りに登録してください。\n「お気に入り」と言ってくれればいつでもお気に入りに登録した曲が見られます。\n左下のメニューからも、会話を始められます。\n気が向いた時に話しかけてくれたら嬉しいです。",
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
      elsif text == "探す"
      sender.reply({ "attachment":{
            "type":"template",
            "payload":{
                "template_type":"button",
                "text":"#{profile_last_name} #{profile_first_name}さん、いまどんな気分ですか？",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"テンションを上げたい",
                        "payload":"hightempo"
                    },
                    {
                        "type":"postback",
                        "title":"リラックスしたい",
                        "payload":"lowtempo"
                    },
                    {
                        "type":"postback",
                        "title":"どっちでもない",
                        "payload":"freeword"
                    }
                ]
            }
        }
      })
        elsif text == "こんにちは"
          sender.reply({ "attachment":{
                            "type":"template",
                            "payload":{
                                "template_type":"button",
                                "text":"#{profile_last_name} #{profile_first_name}さん、こんにちは。",
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
                                    }
                                ]
                            }
                          }
                      })
            
        elsif text.include?("つらい")
          sender.reply({ text: "つらいですよね〜わかります〜"})
        else
        # elsif text == "おすすめ"
        #   sender.reply({ text: "おすすめを教えます！"})
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
                "text":"#{profile_last_name} #{profile_first_name}さん、いまどんな気分ですか？",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"テンションを上げたい",
                        "payload":"hightempo"
                    },
                    {
                        "type":"postback",
                        "title":"リラックスしたい",
                        "payload":"lowtempo"
                    },
                    {
                        "type":"postback",
                        "title":"どっちでもない",
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
                "text":"ノリノリって言ったらこんな感じですかね？",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"クラブで踊りたい",
                        "payload":"clubmusic2"
                        
                    },
                    {
                        "type":"postback",
                        "title":"サーフィンがしたい",
                        "payload":"shonan2"
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
                "text":"リラックスといえばこんな感じですかね？",
                "buttons":[
                    {
                        "type":"postback",
                        "title":"地中海のリゾートでのんびりしたい",
                        "payload":"bossanova2"
                        
                    },
                    {
                        "type":"postback",
                        "title":"ホテルのラウンジでお酒を飲みたい",
                        "payload":"realjazz"
                    }
                ]
            }
          }
      })
      when "freeword"
          sender.reply({ text: "じゃあ、どんな気分か言ってみてください。なるべく探してみるので・・・" })
      #曲を紹介する
      when "clubmusic2"
          @@music = Music.find_by(genre: "clubmusic2")
          sender.reply({ "attachment":{
             "type":"template",
             "payload":{
                 "template_type":"button",
                 "text":"私のイチオシです！\n#{@@music.artist}の#{@@music.musicname}はどうですか？",
                 "buttons":[
                     {
                         "type":"web_url",
                         "url":"#{@@music.url}",
                         "title":"聴いてみる"
                        
                     },
                     {
                         "type":"postback",
                         "title":"気に入った！",
                         "payload":"favorite"
                     },
                     {
                         "type":"postback",
                         "title":"もう一度探す",
                         "payload":"lookformusic"
                     }
                 ]
             }
           }
       })
   
      when "shonan2"
          @@music = Music.find_by(genre: "shonan2")
          sender.reply({ "attachment":{
             "type":"template",
             "payload":{
                 "template_type":"button",
                 "text":"爽やかですねー！\n#{@@music.artist}の#{@@music.musicname}はどうですか？",
                 "buttons":[
                     {
                         "type":"web_url",
                         "url":"#{@@music.url}",
                         "title":"聴いてみる"
                        
                     },
                     {
                         "type":"postback",
                         "title":"気に入った！",
                         "payload":"favorite"
                     },
                     {
                         "type":"postback",
                         "title":"もう一度探す",
                         "payload":"lookformusic"
                     }
                 ]
             }
           }
       })
      when "bossanova2"
          @@music = Music.find_by(genre: "bossanova2")
          sender.reply({ "attachment":{
             "type":"template",
             "payload":{
                 "template_type":"button",
                 "text":"わかります。\n#{@@music.artist}の#{@@music.musicname}はどうですか？",
                 "buttons":[
                     {
                         "type":"web_url",
                         "url":"#{@@music.url}",
                         "title":"聴いてみる"
                        
                     },
                     {
                         "type":"postback",
                         "title":"気に入った！",
                         "payload":"favorite"
                     },
                     {
                         "type":"postback",
                         "title":"もう一度探す",
                         "payload":"lookformusic"
                     }
                 ]
             }
           }
       })
      when "realjazz"
          @@music = Music.find_by(genre: "realjazz")
          
           sender.reply({ "attachment":{
             "type":"template",
             "payload":{
                 "template_type":"button",
                 "text":"おしゃれですね！\n#{@@music.artist}の#{@@music.musicname}はどうですか？",
                 "buttons":[
                     {
                         "type":"web_url",
                         "url":"#{@@music.url}",
                         "title":"聴いてみる"
                        
                     },
                     {
                         "type":"postback",
                         "title":"気に入った！",
                         "payload":"favorite"
                     },
                     {
                         "type":"postback",
                         "title":"もう一度探す",
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
                "text":"あなたの気分に合いそうな曲を教えます。\nいい！と思ったら、お気に入りに登録してください。\n「お気に入り」と言ってくれればいつでもお気に入りに登録した曲が見られます。\n左下のメニューからも、会話を始められます。\n気が向いた時に話しかけてくれたら嬉しいです。",
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
                "text":"よかったです！\nお気に入りに登録しました。",
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
                                        "title":"聞く"
                                        
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