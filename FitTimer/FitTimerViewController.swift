//
//  FitTimerViewController.swift
//  FitTimer
//
//  Created by 이상도 on 2023/02/09.
//

import Foundation
import UIKit
import UserNotifications

class FitTimerViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var alarmOffImage: UIImageView!
    @IBOutlet weak var alarmOnImage: UIImageView!
    
    var finishSetCount = 0
    var finishTimeCount = 0
    var finishHour = ""
    var finishMin = ""
    var finishSec = ""
    
    var startTimer:Date? // background 들어가는 시간 기록하기 위해서
    
    var A = 0
    var B = 0
    var minZero = 0
    var secZero = 0
    @IBOutlet weak var picker: UIPickerView! // Picker
    
    @IBOutlet weak var setCountLabel: UILabel! // ? 세트 종료
    var setCount = 0
    @IBOutlet weak var totalSetLabel: UILabel!
    var totalSetCount = 0
    
    @IBOutlet weak var workoutTimeLabel: UILabel! // '운동시간'라벨
    @IBOutlet weak var breakTimeLabel: UILabel!
    let PICKER_VIEW_COLUMN = 1 //Picker View의 열의 개수를 1개로 지정
    var min: [String] = ["0","1","2","3","4","5","6","7","8","9"]
    var sec: [String] = ["00","05","10","15","20","25","30","35","40","45","50","55"]
    
    @IBOutlet weak var setClearText: UIButton! // 세트 초기화 버튼
    @IBOutlet weak var clear: UIButton! // 처음부터(초기화) 버튼
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var TimerLabel: UILabel! // 스탑워치 Label
    @IBOutlet weak var startStopButton: UIButton! // 시작
    @IBOutlet weak var resetButton: UIButton! // 종료
    
    // 운동 시작 스탑워치
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    
    // 운동종료 쉬는시간 타이머
    var breakTimeTimer : Timer = Timer()
    var count2:Int = 0
    var timerCounting2:Bool = false
    
    // 총 운동시간
    var totalTimeTimer : Timer = Timer()
    var count3: Int = 0
    var timerCounting3:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.isEnabled = false
        clear.isEnabled = false
        
        totalSetLabel.isHidden=true
        totalLabel.isHidden=true
        
        totalSetLabel.text="\(totalSetCount) sets"
        totalLabel.text="00:00:00"
        
        setClearText.layer.cornerRadius=20
        clear.layer.cornerRadius=20
        startStopButton.layer.cornerRadius=20
        resetButton.layer.cornerRadius=20
        
        picker.delegate = self    //delegate 설정
        picker.dataSource = self    //delegate 설정
        
        // push 알림 구현
        alarmOffImage.isHidden=true
        alarmOnImage.isHidden=false
        let tapGestureOn = UITapGestureRecognizer(target: self, action: #selector(alarmImageOnTapped))
        alarmOnImage.addGestureRecognizer(tapGestureOn)
        alarmOnImage.isUserInteractionEnabled = true
        
        let tapGestureOff = UITapGestureRecognizer(target: self, action:#selector(alaramImageOffTapped))
        alarmOffImage.addGestureRecognizer(tapGestureOff)
        alarmOffImage.isUserInteractionEnabled = true
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (didAllow, error) in
            guard let err = error else {
                print(didAllow)
                return
            }
            print(err.localizedDescription)
        }
    }
    
    // 알람 On 이미지 터치시 -> Off 하겠냐는
    @objc func alarmImageOnTapped() {
        
        let alert = UIAlertController(title: "알림", message: "쉬는시간 종료 알림을 끄시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: { _ in
            self.alarmOnImage.isHidden = false
        }))
        
        alert.addAction(UIAlertAction(title: "예", style: .default, handler: { _ in
            self.alarmOnImage.isHidden = true
            self.alarmOffImage.isHidden = false
            
        }))
        self.present(alert,animated: true,completion: nil)
    }
    
    // 알람 Off 이미지 터치시 -> On하는
    @objc func alaramImageOffTapped() {
        alarmOffImage.isHidden = true
        alarmOnImage.isHidden = false
    }
    
    //Picker View에서 선택할 수 있는 행의 개수를 정수 값으로 넘겨주는 delegate method
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return min.count
        } else {
            return sec.count
        }
    }
    
    // pickerView에 담긴 아이템의 컴포넌트 갯수
    // pickerView는 여러 개의 wheel이 있을 수 있다.
    // 여기서는 2개의 wheel을 가진 pickerView를 표현했다.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    //각 열의 타이틀을 문자열로 넘겨주는 delegate method
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return min[row]+" 분"
        } else {
            return sec[row]+" 초"
        }
    }
    
    // picker의 선택된 값
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            if row == 0 {
                minZero = 1
            }
            A = row * 60
        case 1:
            if row == 0 {
                secZero = 1
            }
            B = row * 5
        default:
            break;
        }
        
    }
    
    @IBAction func setClearTapped(_ sender: Any) {
        setCount=0
        setCountLabel.text = "\(setCount) 세트 종료"
    }
    
    // 종료 버튼
    @IBAction func resetTapped(_ sender: UIButton) {
        //self.count = 0 // 상승하는 count를 다시 0으로 설정
        setCount += 1 // 종료 누를때마다 세트 수 세기
        setCountLabel.text = "\(setCount) 세트 종료"
        totalSetCount += 1
        totalSetLabel.text = "\(totalSetCount) sets"
        self.timer.invalidate() // 타이머를 중지하는 timer.invalidate() 호출 invalidate:무효화
        self.TimerLabel.text = self.makeTimeString(minutes: A/60, seconds:B)
        resetButton.setTitleColor(UIColor.systemGray2, for: .normal)
        resetButton.backgroundColor=UIColor.systemGray6
        resetButton.isEnabled=false
        setCountLabel.textColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0)
        TimerLabel.textColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0)
        workoutTimeLabel.textColor = UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0)
        workoutTimeLabel.text="휴식 시간"
        count2=A+B
        breakTimeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(breakTimer), userInfo: nil, repeats: true)
    }
    
    // 시작 버튼
    @IBAction func startStopTapped(_ sender: UIButton) {
        if(timerCounting) // 타이머가 시간을 계산중이라면
        {
            timerCounting = false // timerCounting은. false
            timer.invalidate() // 사용자가 startStop버튼을 탭하면 타이머를 중지하는 timer
            startStopButton.setTitleColor(UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0), for: .normal)
        }
        else{ // 타이머가 시간을 계산중이 아니라면
            timerCounting = true
            totalSetLabel.isHidden=false
            totalLabel.isHidden=false
            breakTimeLabel.layer.isHidden = true
            picker.layer.isHidden=true
            resetButton.isEnabled=true
            clear.isEnabled=true
            startStopButton.setTitleColor(UIColor.systemGray2, for: .normal)
            startStopButton.isEnabled=false
            startStopButton.backgroundColor=UIColor.systemGray6
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            totalTimeTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(totalCounter), userInfo: nil, repeats: true)
        }
    }
    
    // 운동시간 Timer
    @objc func timerCounter() -> Void {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds:count)
        let timeString = makeTimeString(minutes:time.0, seconds: time.1)
        TimerLabel.text=timeString
    }
    func secondsToHoursMinutesSeconds(seconds:Int) ->(Int, Int) {
        return ( ((seconds%3600)/60), ((seconds%3600)%60))
    }
    func makeTimeString(minutes:Int, seconds: Int) -> String{
        var timeString = ""
        timeString+=String(format: "%02d", minutes)
        timeString+=" : "
        timeString+=String(format: "%02d", seconds)
        return timeString
    }
    
    // 쉬는시간 Timer
    @objc func breakTimer() -> Void {
        if count2 != 0 {
            count2 -= 1
        }
        let time2 = breakTime(seconds:count2)
        let timeString2 = makeTimeString2(minutes:time2.0, seconds: time2.1)
        TimerLabel.text=timeString2
        if minZero == 1 && secZero == 1 {
            breakTimeTimer.invalidate()
            self.count=0
            resetButton.isEnabled=true
            self.resetButton.backgroundColor=UIColor.white
            self.resetButton.setTitleColor(UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0), for: .normal)
            TimerLabel.textColor = UIColor.black
            workoutTimeLabel.textColor = UIColor.black
            workoutTimeLabel.text="운동 시간"
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
        if count2 == 0 { // 쉬는시간 끝나면 자동으로 운동시간 시작
            
            // 쉬는시간 끝날때마다 push 알림
            if(alarmOnImage.isHidden == false){
                let content = UNMutableNotificationContent()
                content.title = "휴식 시간 종료"
                content.body = "운동을 시작해주세요."
                //content.badge = 1
                content.sound = .default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(identifier: "timer", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
            
            breakTimeTimer.invalidate()
            self.count=0
            resetButton.isEnabled=true
            self.resetButton.backgroundColor=UIColor.white
            self.resetButton.setTitleColor(UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0), for: .normal)
            TimerLabel.textColor = UIColor.black
            workoutTimeLabel.textColor = UIColor.black
            workoutTimeLabel.text="운동 시간"
            setCountLabel.textColor=UIColor.black
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }
    
    func breakTime(seconds:Int) -> (Int, Int) {
        return ( ((seconds%3600)/60), ((seconds%3600)%60))
    }
    
    func makeTimeString2(minutes:Int, seconds: Int) -> String {
        var timeString2 = ""
        timeString2+=String(format:"%02d", minutes)
        timeString2+=" : "
        timeString2+=String(format: "%02d", seconds)
        return timeString2
    }
    
    // 총 운동시간 Timer ( Total Time )
    @objc func totalCounter() -> Void {
        count3 = count3 + 1
        let time3 = totalTime(seconds: count3)
        let timeString3 = makeTimeString3(hours: time3.0, minutes:time3.1, seconds: time3.2)
        totalLabel.text=timeString3
    }
    
    func totalTime(seconds:Int) ->(Int, Int, Int) {
        return ( (seconds/3600),((seconds%3600)/60), ((seconds%3600)%60))
    }
    
    func makeTimeString3(hours:Int, minutes:Int, seconds: Int) -> String{
        var timeString3 = ""
        timeString3+=String(format: "%02d", hours)
        timeString3+=":"
        timeString3+=String(format: "%02d", minutes)
        timeString3+=":"
        timeString3+=String(format: "%02d", seconds)
        return timeString3
    }
    
    // 운동 종료
    @IBAction func clear(_ sender: Any) {
        
        // 기본 속성 설정
        breakTimeLabel.layer.isHidden = false
        picker.layer.isHidden = false
        startStopButton.isEnabled = true
        resetButton.isEnabled=false
        self.resetButton.backgroundColor=UIColor.white
        self.resetButton.setTitleColor(UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0), for: .normal)
        self.startStopButton.setTitleColor(UIColor(red:0.0, green:122.0/255.0, blue:1.0, alpha:1.0), for: .normal)
        self.startStopButton.backgroundColor=UIColor.white
        TimerLabel.textColor = UIColor.black
        workoutTimeLabel.textColor = UIColor.black
        workoutTimeLabel.text="운동 시간"
        setCountLabel.textColor = UIColor.black
        
        // 스탑워치 초기화
        finishTimeCount = count3
        self.count = 0 // 상승하는 count를 다시 0으로 설정
        self.count2 = 0
        self.count3 = 0
        self.setCount = 0
        self.setCountLabel.text = "\(setCount) 세트 종료"
        self.timer.invalidate() // 타이머를 중지하는 timer.invalidate() 호출 invalidate:무효화
        self.breakTimeTimer.invalidate()
        self.totalTimeTimer.invalidate()
        
        self.totalLabel.text = self.makeTimeString3(hours: 0, minutes: 0, seconds: 0)
        self.TimerLabel.text = self.makeTimeString(minutes: 0, seconds:0)
        finishSetCount = totalSetCount
        totalSetCount = 0
        self.totalSetLabel.text="\(totalSetCount) sets"
        totalSetLabel.isHidden=true
        totalLabel.isHidden=true
        
        // 최종적인 Total 운동시간을 Alert 메세지로 보여줄때
        finishHour = String(format:"%02d", finishTimeCount/3600)
        finishMin =  String(format:"%02d", (finishTimeCount%3600)/60)
        finishSec = String(format:"%02d", (finishTimeCount%3600)%60)
        finishTimeCount = 0
        let alert = UIAlertController(title: "운동종료", message: "총 \(finishSetCount)세트\n\(finishHour)시간 \(finishMin)분 \(finishSec)초", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "완료", style: .default, handler: { (_) in
            self.clear.isEnabled=false
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
