//
//  NewTask.swift
//  csc690-TodoApp
//
//  Created by SiuChun Kung on 3/24/19.
//  Copyright © 2019 SiuChun Kung. All rights reserved.
//

import Foundation
import UIKit

class NewTaskViewController: UIViewController {
    
    var EXTRA_TITLE: String?
    var EXTRA_TIME:String?
    var EXTRA_ID: Int?
    
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var newTask: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if EXTRA_TITLE != nil {
            name.text = "Current Task"
            guard let titleData = EXTRA_TITLE else { return }
            guard let timeData = EXTRA_TIME else { return }
            newTask.text = titleData
            dateField.text = timeData
        
        }
    }
    
    
    
    @IBAction func onSubmit(_ sender: Any) {
        if EXTRA_TITLE != nil {
            // edit
           edit()
        } else {
            // create
            create()
        }
      

        doneBtn()
        newTask.endEditing(true)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
    func create() {
        if newTask.text == "" {
            print("Empty tast")
            
        } else {
            task.insert((title: newTask.text!, time: dateField.text!), at: 0)
            let saveData: [[String: Any]] = task.map { ["title": $0.title, "time": $0.time] }
            UserDefaults.standard.set(saveData, forKey: "Todo")
        }
        doneBtn()
        newTask.endEditing(true)
    }
    
    @objc func doneBtn(){
        dateField.resignFirstResponder()
        newTask.becomeFirstResponder()
    }
    
    func edit() {
        if newTask.text == "" {
            task.remove(at: EXTRA_ID!)
            let saveData: [[String: Any]] = task.map { ["title": $0.title, "time": $0.time] }
            UserDefaults.standard.set(saveData, forKey: "Todo")
            
        } else {
            task.remove(at: EXTRA_ID!)
            task.insert((title: newTask.text!, time: dateField.text!), at: 0)
            let saveData: [[String: Any]] = task.map { ["title": $0.title, "time": $0.time] }
            UserDefaults.standard.set(saveData, forKey: "Todo")
        }
    }
    
}
