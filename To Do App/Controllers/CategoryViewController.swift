//
//  CategoryViewControllerTableViewController.swift
//  To Do App
//
//  Created by Данік on 28/01/2023.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {

    

    @IBOutlet weak var kategoryTableView: UITableView!
    
    
    let realm = try! Realm()
    
    
    
    // the Result is a Data Type that is auto updated
    var categoryArray : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        kategoryTableView.delegate = self
        kategoryTableView.dataSource = self
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
        self.kategoryTableView.reloadData()
    }
    
    func loadCategories() {
        
        // pull out all the items from realm that are Category objects
        categoryArray = realm.objects(Category.self)
        
        kategoryTableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return the number of categories that we have if the categoryArray is not nil,
        // if it is return 1 (nil Coalescing Operator)
        return categoryArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // put each categoryArray.name into each cell, if the value is nil put "No Categories added yet"
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"
        
        
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
        
        
        if let indexPath = kategoryTableView.indexPathForSelectedRow {
            // send the information about the selected category to the destinationVC (ToDoListViewControlelr)
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}
