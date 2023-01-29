//
//  CategoryViewControllerTableViewController.swift
//  To Do App
//
//  Created by Данік on 28/01/2023.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController {

    

    @IBOutlet weak var kategoryTableView: UITableView!
    
    var kategoryArray = [Kategory]()
    
    // cast the App delegate an UIApplication object in order to be able to access it
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        kategoryTableView.delegate = self
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
            let newCategoryFromTheTextField = Kategory(context: self.context)
            
            // put the text from the textfield into the constant
            newCategoryFromTheTextField.name = textField.text!
            
            //append the constant to the array of Kategories
            self.kategoryArray.append(newCategoryFromTheTextField)
            
            self.saveCategories()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategories() {
        do {
            // save the context
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        // refresh the TableView
        self.kategoryTableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Kategory> = Kategory.fetchRequest()) {
        // create a constant with a specified datatype <Item>
        // we tap into our Item class/entity and make a new fetch request
        //        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            // put the items that we fetched from the context into an Array called itemArray
            kategoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        kategoryTableView.reloadData()
    }
    
}

// MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kategoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // create a constant item that refers to a cell
        let category = kategoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
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
            destinationVC.selectedKategory = kategoryArray[indexPath.row]
        }
    }
}
