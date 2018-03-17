//
//  ViewController.swift
//  Todoey
//
//  Created by Wu Peirong on 27/1/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeCellViewController {
    
    //MARK: - Global Variables
    
    var todoItem: Results<Item>?
    
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet{
            loadItem()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        
        
        tableView.separatorStyle = .none
        }
        // Do any additional setup after loading the view, typically from a nib.
    
    override func viewWillAppear(_ animated: Bool) {
        
       
        guard let navigationColour = selectedCategory?.hexValue else { fatalError() }
        
        updateNavBar(withHexCode: navigationColour)
        
        title = selectedCategory!.name
            
        
        
           }

    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "FFFFFF")
    }
    
    //MARK: - NavBar Update Method
    
    func updateNavBar(withHexCode colourHexCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        guard let navBarColour = UIColor(hexString: colourHexCode)  else { fatalError() }
        
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
    }
    
    //MARK: - TableView Datasource Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItem?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
            
            if let colour = UIColor(hexString: selectedCategory!.hexValue)?.darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(todoItem!.count))) {
               
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
            }
          
        }
   
        else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItem?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        if let item = todoItem?[indexPath.row] {
            do {
           try realm.write {
                item.done = !item.done
            }
        }
            catch {
                print("Item's status cannot be changed \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemToBeDeleted = todoItem?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(itemToBeDeleted)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }

    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                        print("Error saving Items, \(error)")
                    }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Create New Item"
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItem() {
        
       todoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

//MARK: - Searchbar Delegate Methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItem = todoItem?.filter("title BEGINSWITH[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title BEGINSWITH[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItem(with: request, predicate: predicate )
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
         loadItem()
            
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }
        }
    }
    
}

