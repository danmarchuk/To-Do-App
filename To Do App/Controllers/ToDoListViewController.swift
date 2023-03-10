//
//  ViewController.swift
//  To Do App
//
//  Created by Данік on 21/01/2023.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var toDoTableView: UITableView!
    
    @IBOutlet weak var toDoSearchbar: UISearchBar!
    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        toDoTableView.rowHeight = 60.0
        
        // configure the searchbar colors
        toDoSearchbar.barTintColor = UIColor(hexString: selectedCategory!.color)
        toDoSearchbar.searchTextField.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // color of the navBar
        if let colorHex = selectedCategory?.color {
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller does not exist")}
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor(hexString: colorHex)
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }

    }
    // MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = self.toDoItems?[indexPath.row] {
            do {
                // delete the category
                try self.realm.write {
                    realm.delete(item)
                    
                }
            } catch {
                print("Error deleting item \(error)")
            }
        }
    }
    
}

// MARK: - TableView DataSource methods
extension ToDoListViewController {
    
    // how many cells we want to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    // put content in the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.name
            
            let percentage = CGFloat(indexPath.row) / CGFloat(toDoItems!.count)
            
            let colorFromCategory = UIColor(hexString: selectedCategory!.color)
            
            if let color = colorFromCategory!.darken(byPercentage: percentage) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            

            
            // Ternary operator
            // value = condition ? valueIfTrue : valueIfFalse
            // Set the cell’s accessory type to .checkmark or .none depending if the item.done is true
            cell.accessoryType = item.done == true ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items Added"
        }
        return cell
    }
    

    
}
// MARK: - TableView Delegate protocols

extension ToDoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        // set the value of the title to completed (crUd -> Update data)
        // toDoItems[indexPath.row].setValue("Completed", forKey: "title")
        
        // delete an item (cruD -> Delete data)
        //        context.delete(toDoItems[indexPath.row])
        //        toDoItems.remove(at: indexPath.row)
        
        // check if the Item's property "done" is false and if so set it to true, otherwise set it to false
        //        toDoItems[indexPath.row].done = !toDoItems[indexPath.row].done
        
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
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    // save the context
                    try self.realm.write {
                        // create a(n) (item) constant that will be placed in our database
                        let newItemFromTheTextField = Item()
                        
                        // put the text from the textfield into the constant
                        newItemFromTheTextField.name = textField.text!
                        
                        // add the time when the item was added to the array
                        newItemFromTheTextField.dateCreated = NSDate().timeIntervalSince1970
                        
                        currentCategory.items.append(newItemFromTheTextField)
                        
                    }
                } catch {
                    print("Error saving an item \(error)")
                }
                
            }
            self.toDoTableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(item: Item) {
        
        // refresh the TableView
        self.toDoTableView.reloadData()
    }
    
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        //        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedKategory!.name!)
        //
        //        request.predicate = predicate
        //
        //        do {
        //            // put the items that we fetched from the context into an Array called toDoItems
        //            toDoItems = try context.fetch(request)
        //        } catch {
        //            print("Error fetching data from context \(error)")
        //        }
        if toDoTableView != nil {
            toDoTableView.reloadData()}
    }
    

    
}

// MARK: - Search Bar Delegate
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("name CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: false)
        //        let request: NSFetchRequest<Item> = Item.fetchRequest()
        //
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //
        //        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        //
        //        request.sortDescriptors = [sortDescriptor]
        //
        //        loadItemsForASearchBar(with: request, predicate: predicate)
        
        toDoTableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

