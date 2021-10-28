namespace :selenium do
    desc "seleniumを行うタスク"
    task selenium: :environment do
        require 'selenium-webdriver'

        driver = Selenium::WebDriver.for :chrome
        driver.get "https://www.englishspeak.com/ja/english-words?category_key=1"
        samples = driver.find_elements(:tag_name, "td")
        samples.each do |sample|
            if sample.text != ""
                str = sample.text 
                str1 = str.split("\n")
                if str1[1]
                word = Word.new(name: str1[0], meaning: str1[1])
                word.save
                end
            end
        end
        driver.close
    end
end
