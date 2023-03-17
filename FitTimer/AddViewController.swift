//
//  AddViewController.swift
//  FitTimer
//
//  Created by 이상도 on 2023/03/09.
//

import UIKit

class AddViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tvContents: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textView에 delegate 상속
        tvContents.delegate = self
        
        // 처음 화면이 로드되었을 때 플레이스 홀더처럼 보이게끔 해주기
        tvContents.text = "내용을 입력해주세요."
        tvContents.textColor = UIColor.lightGray
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        if tvContents.text.isEmpty {
            alert(message: "내용을 입력해주세요.")
        }
        else {
            let newMemo = MemoContents(contents: tvContents.text)
            MemoContents.imsiList.append(newMemo)
            
            navigationController?.popViewController(animated: true)
        }
    }
    func alert(title:String="경고", message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "예", style: .default)
        alert.addAction(btnOk)
        present(alert, animated: true,completion: nil)
    }
    
    // 지정된 텍스트 뷰의 편집이 끝나는 시기를 알려주는 메소드
    func textViewDidEndEditing(_ textView: UITextView) {
        if tvContents.text.isEmpty {
            tvContents.text = "내용을 입력해주세요."
            tvContents.textColor = UIColor.lightGray
        }
    }
    
   // 지정된 텍스트 뷰의 편집이 시작할 때를 알려주는 메소드
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tvContents.textColor == UIColor.lightGray{
            tvContents.text = nil
            tvContents.textColor = UIColor.black
        }
    }
    
    // 터치가 이뤄졌을 때 텍스트뷰를 첫번째 반응에 사임시켜, textViewDidEndEditing 실행
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tvContents.resignFirstResponder()
    }
}
