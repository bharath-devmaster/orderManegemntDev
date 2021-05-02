//
//  MainViewController.swift
//  Order Management System
//
//  Created by Apalya on 25/04/21.
//

import UIKit
import CoreData


class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, EditOrderDetailsViewDelegate{

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var orderTableview: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    
    var editPopUpView : EditOrderDetailsView? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Order]?
    var currentItem:Order? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let loadNib = UINib(nibName: "OrderListTableViewCell", bundle: nil)
        self.orderTableview.register(loadNib, forCellReuseIdentifier: "OrderListTableViewCell")
        
        self.orderTableview.dataSource = self;
        self.orderTableview.delegate = self;
        self.fetchOrders()
        self.orderTableview.tableFooterView = UIView()
    }
    
    func fetchOrders() {
        do{
            self.items = try context.fetch(Order.fetchRequest())
            
            DispatchQueue.main.async(){
                self.orderTableview.reloadData()
                print(self.items ?? "")
            }
        }catch{
            print("error while fetching data")
        }
    }
    
    @IBAction func addOrderData(_ sender: Any) {
        
        self.addPopUpViewWithContent(headerTitle: "Add New Order")
    }
    
    
    //Order List Tableview Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListTableViewCell", for: indexPath) as! OrderListTableViewCell
        
        if let myItem:Order = (items?[indexPath.row]){
            cell.nameLabel.text = myItem.customerName
        }
        return cell

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if let order:Order = (items?[indexPath.row]){
            self.addPopUpViewWithContent(headerTitle: "Edit Order Details")
            self.updateViewWithData(selectedItem: order)
        }else{
            print("error in wrapping Data")
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete Order") { (action, view, completion) in
            
            let alertController = UIAlertController(title: "Alert!", message: "Are you Sure, Want to Delete Order?", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Yes".localizedCapitalized, style: .default) { (action:UIAlertAction!) in
                
                if let order = self.items?[indexPath.row]{
                    self.context.delete(order)
                }
                
                do{
                    try self.context.save()
                }catch{
                    print("error while deleting order")
                }
                self.fetchOrders()
            }
            
            let cancelAction = UIAlertAction(title: "No".localizedCapitalized, style: .default) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(OKAction)
            alertController.addAction(cancelAction)
            
            DispatchQueue.main.async(){
                self.present(alertController, animated: true, completion:nil)
            }
            
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    func didSelectedSaveData(editDict: NSMutableDictionary) {
        if let selectedItem:Order = currentItem{
            selectedItem.customerName = editDict.object(forKey: "customerName") as? String
            selectedItem.customerPhone = editDict.object(forKey: "customerPhoneNumber") as? String
            selectedItem.customerAddress = editDict.object(forKey: "customerAddress") as? String
            selectedItem.orderDueDate = editDict.object(forKey: "orderDueDate") as? String
            if let strInt1 = editDict.object(forKey: "orderTotal"){
                if let str161:String = strInt1 as? String{
                    selectedItem.orderTotal =  Int16(str161) ?? 0
                }
            }else{
                selectedItem.orderTotal = 0
            }
            selectedItem.orderNumber = editDict.object(forKey: "orderNumber") as? String
        }else{
            let newOrder:Order = Order(context: self.context)
            newOrder.customerName = editDict.object(forKey: "customerName") as? String
            newOrder.customerPhone = editDict.object(forKey: "customerPhoneNumber") as? String
            newOrder.customerAddress = editDict.object(forKey: "customerAddress") as? String
            newOrder.orderDueDate = editDict.object(forKey: "orderDueDate") as? String
            if let strInt = editDict.object(forKey: "orderTotal"){
                if let str16:String = strInt as? String{
                    newOrder.orderTotal =  Int16(str16) ?? 0
                }
            }else{
                newOrder.orderTotal = 0
            }
            newOrder.orderNumber = editDict.object(forKey: "orderNumber") as? String
        }
        do{
            try self.context.save()
        }catch{
            print("error while adding new order")
        }
        self.didSelectedGoBack()
        self.fetchOrders()
    }
    
    // show Pop Up view with order Details Fields
    func addPopUpViewWithContent(headerTitle:String) {
        if editPopUpView == nil{
            let nib = UINib(nibName: "EditOrderDetailsView", bundle: nil)
            editPopUpView = nib.instantiate(withOwner: self, options: nil)[0] as? EditOrderDetailsView;
        }
        currentItem = nil
        editPopUpView?.frame = CGRect(x: 10, y: 100, width:self.view.bounds.width - 20, height: self.view.bounds.height - 200)
        editPopUpView?.headerLbl.text = headerTitle
        editPopUpView?.layer.cornerRadius = 20
        editPopUpView?.clipsToBounds = true
        editPopUpView?.layer.borderWidth = 2
        editPopUpView?.layer.borderColor = UIColor(named: "000000")?.cgColor
        editPopUpView?.delegate = self
        self.view.addSubview(editPopUpView!);
        self.addBtn.isHidden = true;
    }
    
    func updateViewWithData(selectedItem:Order) {
        if selectedItem != nil && editPopUpView != nil
        {
            currentItem = selectedItem
            editPopUpView?.updateViewWithContent(contentOrder: selectedItem)
        }
    }
    
    func didSelectedGoBack() {
        if editPopUpView != nil{
            editPopUpView?.removeFromSuperview()
            editPopUpView = nil
        }
        self.addBtn.isHidden = false;
        
    }
    
    
}
