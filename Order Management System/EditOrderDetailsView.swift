//
//  EditOrderDetailsView.swift
//  Order Management System
//
//  Created by Apalya on 29/04/21.
//


import UIKit
import Foundation

protocol EditOrderDetailsViewDelegate:class
{
    func didSelectedSaveData(editDict:NSMutableDictionary)
    func didSelectedGoBack()
    
}
class EditOrderDetailsView: UIView {
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var customerPhone: UITextField!
    @IBOutlet weak var customerAddress: UITextField!
    @IBOutlet weak var orderDueDate: UITextField!
    @IBOutlet weak var orderTotal: UITextField!
    @IBOutlet weak var orderNUmber: UITextField!
    @IBOutlet weak var headerLbl: UILabel!
    var editedContent:Order? = nil
    public weak var delegate:EditOrderDetailsViewDelegate? = nil
    
    override class func awakeFromNib() {
        
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        
        self.delegate?.didSelectedGoBack()
    }
    
    @IBAction func editDetailsSaveAction(_ sender: Any) {
        let edtdict:NSMutableDictionary? = [
            "orderNumber":self.orderNUmber.text ?? "",
            "customerName":self.customerName.text ?? "",
            "customerPhoneNumber":self.customerPhone.text ?? "",
            "orderDueDate":self.orderDueDate.text ?? "",
            "customerAddress":self.customerAddress.text ?? "",
            "orderTotal":self.orderTotal.text ?? "90"
        ]
        if let dict:NSMutableDictionary = edtdict{
            self.delegate?.didSelectedSaveData(editDict: dict)
        }else{
            print("data cannot be passed")
        }
    }
    
    func updateViewWithContent(contentOrder:Order)
    {
        if contentOrder == nil
        {
            return
        }
        editedContent = contentOrder
        self.orderNUmber.text = contentOrder.orderNumber ?? ""
        self.customerName.text = contentOrder.customerName ?? ""
        self.customerAddress.text = contentOrder.customerAddress ?? ""
        self.customerPhone.text = contentOrder.customerPhone ?? ""
        self.orderDueDate.text = contentOrder.orderDueDate ?? ""
        let str: String = String(contentOrder.orderTotal)
        if str.count > 0{
            self.orderTotal.text = str
        }
    }
}
