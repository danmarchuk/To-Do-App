//
//  ViewController.swift
//  To Do App
//
//  Created by Данік on 21/01/2023.
//

import UIKit

class ToDoListViewController: UIViewController {
    

    
    @IBOutlet weak var toDoTableView: UITableView!
    
    var toDoCategory: [Item] = [
        Item(name: "Jane", done: true),
        Item(name: "John", done: false),
        Item(name: "Cena", done: true)]

    override func viewDidLoad() {
        super.viewDidLoad()
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
    }


}

// MARK: - TableView DataSource methods
extension ToDoListViewController: UITableViewDataSource {
    
    // how many cells we want to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoCategory.count
    }
    
    // put content in the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
                cell.textLabel?.text = toDoCategory[indexPath.row].name
//                cell.contentView.backgroundColor = UIColor(named: toDoCategory[indexPath.row].color)
                return cell
    }
    
}
    // MARK: - TableView Delegate protocols

extension ToDoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(toDoCategory[indexPath.row].name)

        // checkmark appears and dissappears when a cell was clicked on
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        // deselect a cell when it was clocked on
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
   
    // MARK: - add new items
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        // create an alert
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            //append the text from teh textfield to the array of category
            self.toDoCategory.append(Item(name: textField.text!, done: false))
            // refresh the TableView
            self.toDoTableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


