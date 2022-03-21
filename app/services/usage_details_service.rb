require "json"
require "csv"
require "selenium-webdriver" 

class UsageDetailsService
    def downloadCsv(year, month)

        user = Rails.application.credentials.rakuten[:id]
        pass = Rails.application.credentials.rakuten[:pass]

        dl_folder = '/Users/hirokishinagawa/rakuten'

        # profile作成
        profile = Selenium::WebDriver::Firefox::Profile.new
        # 指定フォルダにダウンロード
        profile["browser.download.folderList"] = 2
        profile["browser.download.dir"] = dl_folder
        # ダウンロードマネージャーを表示しない
        profile["browser.download.manager.showWhenStarting"] = false
        # MIMEタイプを指定
        profile["browser.helperApps.neverAsk.saveToDisk"] = "application/octet-stream;text/csv"

        # option作成
        options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
        options.add_argument('--headless')

        # 接続開始
        browser = Selenium::WebDriver.for :firefox, options: options
        browser.get('https://www.rakuten-card.co.jp/e-navi/')
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        wait.until{browser.find_element(:id, "u").displayed?}

        # id,passを入力
        e = browser.find_element(:id, "u")
        e.clear()
        e.send_keys(user)
        e = browser.find_element(:id, "p")
        e.clear()
        e.send_keys(pass)

        # ログインボタン押下
        button = browser.find_element(:id, "loginButton")
        button.click()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)

        # 明細画面に接続
        browser.get('https://www.rakuten-card.co.jp/e-navi/members/statement/index.xhtml')        
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        wait.until{browser.find_element(:id, "js-payment-calendar-btn").displayed?}

        # カレンダーから指定月の明細に接続
        browser.find_element(:id, "js-payment-calendar-btn").click()
        browser.find_element(:link_text, month).click()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        wait.until{browser.find_element(:id, "js-payment-calendar-btn").displayed?}

        # CSVファイルダウンロード
        csvButton = browser.find_element(:link_text, 'CSV')
        # CSVダウンロードボタンが画面外にあるとクリックできないため、スクロールする
        browser.execute_script('window.scroll(0,' + (csvButton.location.y/2).to_s + ');')
        csvButton.click()

        # ログアウト
        browser.find_element(:link_text, 'ログアウト').click()
        wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        browser.find_element(:xpath, "//img[@alt='ログアウト']").click()

        # 接続終了
        browser.quit()
    end

    def saveRakutenUsage(usageDetail)
        dl_folder = '/Users/hirokishinagawa/rakuten'
        Dir.chdir(dl_folder)
        file = Dir.glob("*").max_by{|f| File.mtime(f)}
        target = dl_folder+'/'+file
        usageDetail.usageAmounts.destroy_all
        CSV.foreach(target, liberal_parsing: true, headers: true) do |row|
            usageDate = row[0]
            udageStore = row[1]
            amount = row[4]
            if amount.empty?
                next
            end
            usageDetail.usageAmounts.create!(usageDate:usageDate, usageStore:udageStore, amount:amount, division:0)
        end
    end

    def calculate(usageDetail)
        sum = 0
        usageDetail.usageAmounts.each do |usageAmount|
            division = usageAmount.division
            amount = usageAmount.amount
            if division == 0
                # 分類1は4割追加
                sum += amount.to_i*0.4
            elsif division == 1
                # 分類2はそのまま追加
                sum += amount.to_i
            elsif division == 2
                # 除外は追加しない
            end
        end
        return sum
    end
end