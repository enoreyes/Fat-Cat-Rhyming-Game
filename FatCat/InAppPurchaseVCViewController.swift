//
//  InAppPurchaseVCViewController.swift
//  FatCat
//
//  Created by Amy Reyes on 9/29/15.
//  Copyright © 2015 Mayan Robot. All rights reserved.
//

import UIKit
import StoreKit

class InAppPurchaseVCViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    
    let productIdentifiers = "hintspurchase"
    var product: SKProduct?
    var realProduct: SKProduct?
    let cellIdentifier = "inappcell"
    let defaults = NSUserDefaults.standardUserDefaults()
    var alert = UIAlertController(title: "Loading", message: "Please Wait", preferredStyle: UIAlertControllerStyle.Alert)
    var connectionAlert = UIAlertController(title: "You aren't Connected to the Internet", message: "Please reconnect and try again", preferredStyle: UIAlertControllerStyle.Alert)
    
    
    @IBOutlet weak var buttonEnabler: UIButton!
    @IBOutlet weak var textEnabler: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        requestProductData()
        
        // print("pachank")
        
        buttonEnabler.enabled = false
        textEnabler.hidden = false
        
        connectionAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            
        }))
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func removeTransaction() {
        SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    }
    
    
    // MARK: - IAP
    
    // BUYING THE OBJECT
    
    @IBAction func buyButton(sender: UIButton) {
        
        if Reachability.isConnectedToNetwork() == true {
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            //print(productsArray)
            
            if realProduct != nil {
                
                let payment = SKPayment(product: realProduct!)
                
                SKPaymentQueue.defaultQueue().addPayment(payment)
                
            } else {
                
            }
            
        } else {
            self.presentViewController(connectionAlert, animated: true, completion: nil)
        }
    }
    
    // REQUESTING PRODUCT DATA
    
    func requestProductData()
    {
        if SKPaymentQueue.canMakePayments() {
            
            let productID:NSSet = NSSet(object: self.productIdentifiers);
            let request = SKProductsRequest(productIdentifiers:
                productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            //print("Bloop")
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
                // print("bleep")
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        //print("request \(request)")
        var products = response.products
        
        
        if (products.count != 0) {
            for var i = 0; i < products.count; i++
            {
                self.product = products[i] as SKProduct
                realProduct = product!
                buttonEnabler.enabled = true
                textEnabler.hidden = true
            }
        } else {
            print("No products found")
        }
        
    }
    
    // DELIVERING PRODUCTS
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions as [SKPaymentTransaction] {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Purchased:
                //print("Transaction Approved")
                //print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                
                break
                
            case SKPaymentTransactionState.Failed:
                //print("Transaction Failed")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                alert.dismissViewControllerAnimated(false, completion: nil)
                break
            default:
                break
            }
    
        }
    }
    
    func deliverProduct(transaction:SKPaymentTransaction) {
        
        if transaction.payment.productIdentifier == "hintspurchase"
        {
            //print("Consumable Product Purchased")
            // Unlock Feature
            SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
            addHints()
        }
        
    }
    
    
    func addHints() {
        //        print("adds 5 more hints")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let numberOfHints = defaults.valueForKey(Constants.userConstants.numberOfHints)
        
        let hintSet =  numberOfHints as! Int + 5
        
        self.defaults.setValue(hintSet, forKey: Constants.userConstants.numberOfHints)
        
        alert.dismissViewControllerAnimated(false, completion: nil)
        
        self.performSegueWithIdentifier("backtohint", sender: nil)
    }
    
    
    
}
