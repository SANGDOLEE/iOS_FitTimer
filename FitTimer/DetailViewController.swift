//
//  DetailViewController.swift
//  FitTimer
//
//  Created by 이상도 on 2023/03/09.
//

import UIKit

class DetailViewController: UIViewController {

    var memo:MemoContents?
    
    let formatter : DateFormatter = {
            let format = DateFormatter()
            format.dateStyle = .long
            format.timeStyle = .none
            return format
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}

extension DetailViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentsCell", for: indexPath)
            cell.textLabel?.text=memo?.contents // 추가
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.textLabel?.text=formatter.string(for:memo?.date) // 추가
            return cell
        default:
            fatalError()
        }
    }
}
