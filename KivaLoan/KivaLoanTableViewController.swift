//
//  KivaLoanTableViewController.swift
//  KivaLoan
//
//  Created by Simon Ng on 4/10/2016.
//  Updated by Simon Ng on 6/12/2017.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class KivaLoanTableViewController: UITableViewController {

    private let kivaLoanURL = "https://api.kivaws.org/v1/loans/newest.json"
    private var loans = [Loan]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        getLatestLoans()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getLatestLoans() {
        guard let loanUrl = URL(string: kivaLoanURL) else { return }
        
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print(error)
                return
            }
            
            // Parse JSON data
            if let data = data {
                self.loans = self.parseJsonData(data: data)
                
                // Reload Table View
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }
        }
        
        task.resume()
    }
    
    func parseJsonData(data: Data) -> [Loan] {
        
        var loans = [Loan]()
        
//        do {
//            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//
//            // Parse JSON data
//            let jsonLoans = jsonResult?["loans"] as! [AnyObject]
//            for jsonLoan in jsonLoans {
//                var loan = Loan()
//                loan.name = jsonLoan["name"] as! String
//                loan.amount = jsonLoan["loan_amount"] as! Int
//                loan.use = jsonLoan["use"] as! String
//                let location = jsonLoan["location"] as! [String: AnyObject]
//                loan.country = location["country"] as! String
//                loans.append(loan)
//            }
//        } catch {
//            print(error)
//        }
        
        // Parse JSON Data using Codable
        let decoder = JSONDecoder()
        
        do {
            let loansDataStore = try decoder.decode(LoanDataStore.self, from: data)
            loans = loansDataStore.loans
        } catch {
            print(error)
        }
        
        return loans
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return loans.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! KivaLoanTableViewCell

        // Configure the cell...
        cell.nameLabel.text = loans[indexPath.row].name
        cell.useLabel.text = loans[indexPath.row].use
        cell.amountLabel.text = "$\(loans[indexPath.row].amount)"
        cell.countryLabel.text = loans[indexPath.row].country
        
        return cell
    }
    


}
