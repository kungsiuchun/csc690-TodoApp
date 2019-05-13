//
//  ViewController.swift
//  csc690-TodoApp
//
//  Created by SiuChun Kung on 3/24/19.
//  Copyright © 2019 SiuChun Kung. All rights reserved.
//

import UIKit


var task = [(title: String, time: String)]()

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = UserDefaults.standard
        
        guard let loadData = defaults.object(forKey: "Todo") as? [[String: Any]] else {
            return
        }
        task = loadData.map { (title: $0["title"] as! String, time: $0["time"] as! String) }
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

        tableView.delegate = self
        tableView.dataSource = self
        // add refresh control to table view
          getHomeline()
        
    }

    @objc func refreshControlAction(_ refreshControl: UIRefreshControl){
          getHomeline()
    }
    func getHomeline(){
        tableView.reloadData()
        refreshControl.endRefreshing()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let task = self.task[indexPath.row]
//        let cell = UITableViewCell()
//        cell.textLabel?.text = task.displayText
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoListCell

        let TodoData = task[(indexPath as NSIndexPath).row]
        let text = TodoData.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let time = TodoData.time

        cell.title.text = text
        cell.time.text = time
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            task.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let saveData: [[String: Any]] = task.map{(["title": $0.title, "time": $0.time])
            }
            UserDefaults.standard.set(saveData, forKey: "Todo")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let TodoData = task[(indexPath as NSIndexPath).row]
                let titleData = TodoData.title //
                let timeData = TodoData.time //
                let idData = indexPath.row
                let addC = segue.destination as! NewTaskViewController
                addC.EXTRA_TITLE = titleData
                addC.EXTRA_TIME = timeData
                addC.EXTRA_ID = idData
            }
        }
    }
}

