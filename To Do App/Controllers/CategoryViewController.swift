//
//  CategoryViewControllerTableViewController.swift
//  To Do App
//
//  Created by Данік on 28/01/2023.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UIViewController {

    
    
    
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    let realm = try! Realm()
    
    // the Result is a Data Type that is auto updated
    var categoryArray : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.rowHeight = 80.0
        loadCategories()
        
    }
    
    
    // when the add button is pressed we can add a Kategory to the array of Kategories
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        // create an alert
        let alert = UIAlertController(title: "Add new Category", message: "",
                                      preferredStyle: .alert)
        alert.becomeFirstResponder()
        
        // create a button in the allert message called "Add Category"
        let action = UIAlertAction(title: "Add Category", style: .default) { (action)
            in
            // create a (Kategory) constant that will be placed in our database
            let newCategoryFromTheTextField = Category()
            
            // put the text from the textfield into the constant
            newCategoryFromTheTextField.name = textField.text!
            
            
            self.save(category: newCategoryFromTheTextField)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category) {
        do {
            // save the context
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        // refresh the TableView
        self.categoryTableView.reloadData()
    }
    
    func loadCategories() {
        
        // pull out all the items from realm that are Category objects
        categoryArray = realm.objects(Category.self)
        
        categoryTableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return the number of categories that we have if the categoryArray is not nil,
        // if it is return 1 (nil Coalescing Operator)
        return categoryArray?.count ?? 1
    }
    
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        // put each categoryArray.name into each cell, if the value is nil put "No Categories added yet"
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"
        
        
//        cell.layer.cornerRadius = 20
//        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
//        cell.layer.shadowRadius = 3
//        cell.layer.shadowOpacity = 0.3
//        cell.layer.shouldRasterize = true
//        cell.layer.rasterizationScale = UIScreen.main.scale

        
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        
        if let indexPath = categoryTableView.indexPathForSelectedRow {
            // send the information about the selected category to the destinationVC (ToDoListViewControlelr)
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}

// MARK: - SwipeTableViewCellDelegate
extension CategoryViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [self] action, indexPath in
            if let category = self.categoryArray?[indexPath.row] {
                do {
                    // delete the category
                    try self.realm.write {
                        realm.delete(category)
                        
                    }
                } catch {
                    print("Error deleting caregory \(error)")
                }
//                categoryTableView.reloadData()
            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructiveAfterFill
        return options
    }

}


