module LandingsHelper
  
  def weathers
    @weathers = ["晴れ",
                 "晴れ時々曇り",
                 "晴れ時々雨",
                 "曇り",
                 "曇り時々晴れ",
                 "曇り時々雨",
                 "雨",
                 "大雨",
                 "雷雨",
                 "嵐",
                 "大嵐",
                 "雪",
                 "大雪"]
  end
  
  def fish_species
    @fish_species = ["鯖",
                     "若子",
                     "鮭",
                     "するめ",
                     "セズ",
                     "鮑口開",
                     "子イカ",
                     "鯛",
                     "鰯",
                     "汐子",
                     "セグロ",
                     "鯵"]
  end

  def wind
    @wind = ["風あり",
             "風なし"]
  end
  
  def wave
    @wave = ["波あり",
             "波なし"]
  end
  
end
