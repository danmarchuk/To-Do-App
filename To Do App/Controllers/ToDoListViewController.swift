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
    
    // cast the App delegate an UIApplication object in order to be able to access it
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    // Plus button pressed
    @IBAction func plusButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        // create an alert
        let alert = UIAlertController(title: "Add new Item", message: "",
                                      preferredStyle: .alert)
        
        // create a button in the allert message called "Add Item"
        let action = UIAlertAction(title: "Add Item", style: .default) { (action)
            in
            // create a(n) (item) constant that will be placed in our database
            let newItemFromTheTextField = Item(context: self.context)
            
            // put the text from the textfield into the constant
            newItemFromTheTextField.title = textField.text!
            
            // set the value of done to false
            newItemFromTheTextField.done = false
            
            //append the constant to the array of Items
            self.toDoCategory.append(newItemFromTheTextField)
            
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems() {
        do {
            // save the context
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        // refresh the TableView
        self.toDoTableView.reloadData()
    }
}


