# coding: utf-8

User.create!(name: "管理者",
             email: "admin@email.com",
             password: "password",
             password_confirmation: "password",
             admin: true)
             
User.create!(name: "経理",
             email: "account@email.com",
             password: "password",
             password_confirmation: "password",
             accounting: true)
             
User.create!(name: "一般テストユーザー",
             email: "test@email.com",
             password: "password",
             password_confirmation: "password"
             )
             
             
             
             
             
             
             
Ground.create!(fishing_ground_name: "四丁目",
              )
              
Ground.create!(fishing_ground_name: "三丁目",
              )
              
Ground.create!(fishing_ground_name: "三貫",
              )
              
Ground.create!(fishing_ground_name: "汐折",
              )
              
Ground.create!(fishing_ground_name: "ほっちょうか",
              )
              
Ground.create!(fishing_ground_name: "下り松",
              )
              
Ground.create!(fishing_ground_name: "白崎",
              )
              
Ground.create!(fishing_ground_name: "釜沖",
              )
              
Ground.create!(fishing_ground_name: "小松",
              )
              
Ground.create!(fishing_ground_name: "金島",
              )
              
Ground.create!(fishing_ground_name: "大建",
              )
              
Ground.create!(fishing_ground_name: "仲網",
              )
