import UIKit
import Foundation // Timerクラスを使用するために必要なモジュール
import PlaygroundSupport // Playground上でTimerクラスを機能させるために必要なモジュール

//仕様
//- 500W 600W 700Wとワット数を変更できる - enumで設定？（選択W数ごとに温度上限も変更されるように）
//- 500Wを選択中: 上限温度は120度 、600Wを選択中: 上限温度は130度、700Wを選択中: 上限温度は140度
//- 500Wの時は毎秒3度上昇、600Wの時は毎秒5度上昇、700Wの時は毎秒8度上昇するようにする
//- タイマーをセット（設定したタイマーからカウントダウンしていくように）
//- 設定したタイマーが終了するとちんっと鳴る
//- タイマーの設定時間は最大15分とする

//例外ケース
// - タイマーの設定時間が15分以上だった場合は、処理を実行せず、15分以上のタイマーは設定できませんと出力
// - 選択W数ごとに選択したW数、温度上限を設定
// - 設定した上限温度を超えた場合、処理を中断する

// デフォルトだとTimerクラスを継続的に処理させることが出来ないため、フラグを変更
PlaygroundPage.current.needsIndefiniteExecution = true


class Microwave {
//Timerクラスを利用する
    var timer = Timer()

    //秒と分の変数を用意
    var seconds:Int = 0
    var minutes:Int = 0
    var limit = 0 //これは制限時間です。
    var temperature = 0 //現在の電子レンジの温度
    var limitTemperature = 0 //電子レンジの上限温度
    var risingTemperature = 0 //1秒ごとの上昇温度
    

    
    //ワット数選択
    enum selectMode {
        case sevenHundredWatts //700W
        case sixHundredWatts //600W
        case fiveHundredWatts //500W
        
    }
    //タイマーをスタートさせるメソッド
    func startTimer(type: selectMode) {
        //if文からguard文に変更
        guard limit < 15 else {
            print("15分以上のタイマーは設定できません")
            return
        }
        setUpTimer()
        timer.invalidate() //timer = nilのイメージ。タイマーを止める
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        //↑1秒毎に自分のupdateTimerメソッドを繰り返し呼び出す。
        switch type {
        case .sevenHundredWatts:
            print("700Wを選択中: 上限温度は140度です")
            limitTemperature = 140 //上限温度
            risingTemperature = 3 //毎秒上昇する温度
        case .sixHundredWatts:
            print("600Wを選択中: 上限温度は130度です")
            limitTemperature = 130
            risingTemperature = 5
        case .fiveHundredWatts:
            print("500Wを選択中: 上限温度は120度です")
            limitTemperature = 120
            risingTemperature = 8
            
        }
        
    }

    //startTimerメソッドで、繰り返し呼ばれるメソッド
    //タイマーが回っている途中、変数の内容を更新
    @objc func updateTimer() {
        seconds -= 1
        temperature += risingTemperature //1秒ごとに上昇
        if temperature <= limitTemperature {
            if seconds <= -1 {
                minutes -= 1
                seconds = 59
            }
            if minutes == 0 && seconds == 0 { //タイマーが終わったら・・ 分数が0かつ秒数が0になったらresetTimerへ
                resetTimer()
                print("チンっ！（カウントダウン終了）")
            }
            print(seconds)
            print(minutes)
        }
        
    }

    //タイマーの最初の設定を行う。変数の初期化
    func setUpTimer() {
            seconds = 0
            minutes = limit
            print(seconds)
            print(minutes)
    }
    //リセットボタン
        func resetTimer() {
            timer.invalidate() //タイマーを止める
            setUpTimer()
        }

}

let alarm = Microwave()
alarm.limit = 10  //タイマーを入力
alarm.startTimer(type: .sixHundredWatts)
