//
//  MemoListTableViewController.swift
//  FitTimer
//
//  Created by 이상도 on 2023/03/20.
//

import UIKit

class MemoListTableViewController: UITableViewController {

    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.locale = Locale(identifier: "ko_KR")
        f.setLocalizedDateFormatFromTemplate("MMM yyyy")
        f.timeStyle = .none
        return f
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataManager.shared.fetchMemo() // 배열이 Data로 채워진다.
        tableView.reloadData() // tableView 업데이트
        
        //tableView.reloadData()
    }
    
    //var token : NSObjectProtocol?
    /*
    deinit {
        if let token = token{
            NotificationCenter.default.removeObserver(token)
        }
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailViewController {
                vc.memo = DataManager.shared.memoList[indexPath.row]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor=UIColor.systemGray6
        NotificationCenter.default.addObserver(self, selector: #selector(self.didDismissComposeViewNotification(_:)), name: NSNotification.Name("DismissComposeView"), object: nil)

    }

    // MARK: - Table view data source
    @objc func didDismissComposeViewNotification(_ notification: Notification){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.shared.memoList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let target = DataManager.shared.memoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(for: target.insertDate)

        return cell
    }
    
    // 목록 Swipe 삭제 구현
    // 편집 기능 활성화 = return true
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let target = DataManager.shared.memoList[indexPath.row]
            DataManager.shared.deleteMemo(target)
            DataManager.shared.memoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            
        }    
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
