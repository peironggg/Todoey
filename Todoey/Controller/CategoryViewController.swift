//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Wu Peirong on 14/2/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeCellViewController {

    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       tableView.rowHeight = 80.0
       tableView.separatorStyle = .none
        
       loadCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - TableView Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categoryArray?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No Category Yet"
        
        guard let backgroundColor = UIColor(hexString: (category?.hexValue ?? "FFFFFF")) else { fatalError()}
        
        cell.backgroundColor = backgroundColor
        
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
        
        return cell
    }
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        
      }
    }
    
    // MARK: - Data Manipulation Methods
  
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.hexValue = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
        
    }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Create New Item"
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
}
   
    func save(category: Category) {

        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving category, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategory() {
        
       categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryToBeDeleted = categoryArray?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(categoryToBeDeleted)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}


