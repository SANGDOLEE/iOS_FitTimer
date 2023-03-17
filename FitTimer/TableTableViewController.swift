//
//  TableTableViewController.swift
//  FitTimer
//
//  Created by 이상도 on 2023/03/09.
//

import UIKit

class TableTableViewController: UITableViewController {
    
    @IBOutlet var tvListView: UITableView!
    
    let formatter : DateFormatter = {
            let format = DateFormatter()
            format.dateStyle = .long
            format.timeStyle = .none
            return format
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemGray6
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "sgDetail" {
            let detailView = segue.destination as! DetailViewController
            let cell = sender as! UITableViewCell
            let indexPath = self.tvListView.indexPath(for:cell)
            
            detailView.memo = MemoContents.imsiList[indexPath!.row]
        }
         
    }
     
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MemoContents.imsiList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let target = MemoContents.imsiList[indexPath.row]
        
        cell.textLabel?.text = target.contents
        cell.detailTextLabel?.text = formatter.string(from:target.date)

        return cell
    }
    
    
    // cell 스와이프 삭제
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        if editingStyle == .delete{
            MemoContents.imsiList.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
}
