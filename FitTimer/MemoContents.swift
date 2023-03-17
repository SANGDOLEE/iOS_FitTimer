//
//  Model.swift
//  FitTimer
//
//  Created by 이상도 on 2023/03/05.
//

import Foundation

class MemoContents {
    var contents :  String
    var date : Date
    
    init(contents: String){
        self.contents = contents
        date = Date()
    }
    
    static var imsiList:[MemoContents] = [
        //MemoContents(contents : "일지를 입력해주세요."),
        //MemoContents(contents : "두번째 메모")
    ]
}
