//
//  ViewController.swift
//  To Do App
//
//  Created by Данік on 21/01/2023.
//

import UIKit

class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    var toDoCategory = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        
        let newItem = Item()
        newItem.title = "Find Mike"
        
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
        
        // create a constant item that refers to a cell
        let item = toDoCategory[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        // Set the cell’s accessory type to .checkmark or .none depending if the item.done is true
        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }
    
}
// MARK: - TableView Delegate protocols

extension ToDoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(toDoCategory[indexPath.row].title)
        
        // check if the Item's property "done" is false and if so set it to true, otherwise set it to false
        toDoCategory[indexPath.row].done = !toDoCategory[indexPath.row].done
        
        self.toDoTableView.reloadData()
        
        // deselect a cell when it was clicked on
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK: - add new items
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        // create an alert
        let alert = UIAlertController(title: "Add new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UIAlert
            //append the text from teh textfield to the array of Items
            let newItemFromTheTextField = Item()
            newItemFromTheTextField.title = textField.text!
            self.toDoCategory.append(newItemFromTheTextField)
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


