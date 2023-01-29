//
//  ViewController.swift
//  To Do App
//
//  Created by Данік on 21/01/2023.
//

import UIKit
import CoreData

class ToDoListViewController: UIViewController {
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    var itemArray = [Item]()
    
    var selectedKategory : Kategory? {
        didSet{
            loadItems()
        }
    }
    
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
        return itemArray.count
    }
    
    // put content in the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        
        // create a constant item that refers to a cell
        let item = itemArray[indexPath.row]
        
        // populate each cell with title of the item
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
        
        // set the value of the title to completed (crUd -> Update data)
        // itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        // delete an item (cruD -> Delete data)
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        // check if the Item's property "done" is false and if so set it to true, otherwise set it to false
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
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
        alert.becomeFirstResponder()
        
        // create a button in the allert message called "Add Item"
        let action = UIAlertAction(title: "Add Item", style: .default) { (action)
            in
            // create a(n) (item) constant that will be placed in our database
            let newItemFromTheTextField = Item(context: self.context)
            
            // put the text from the textfield into the constant
            newItemFromTheTextField.title = textField.text!
            
            // set the value of done to false
            newItemFromTheTextField.done = false
            
            newItemFromTheTextField.parentCategory = self.selectedKategory
            
            //append the constant to the array of Items
            self.itemArray.append(newItemFromTheTextField)
            
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
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedKategory!.name!)
        
        request.predicate = predicate
        
        do {
            // put the items that we fetched from the context into an Array called itemArray
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        if toDoTableView != nil {
            toDoTableView.reloadData()}
    }
    
    // function load items uses an optional that has a default value of nill
    func loadItemsForASearchBar(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        // create a predicate that matches the category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedKategory!.name!)
        
        // if we have a predicate as an argument in the function then we use compound predicate
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            // if we don't have the second argument use the value of the category
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            // put the items that we fetched from the context into an Array called itemArray
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        if toDoTableView != nil {
            toDoTableView.reloadData()}
    }
    
    
}

// MARK: - Search Bar Delegate
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            // put the items that we fetched from the context into an Array called itemArray
             itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
}

