//
//  DetailViewController.swift
//  Demonstration
//
//  Created by Neil on 26/01/17.
//  Copyright © 2017 Neil's Ultimate Lab. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var profile: Profile? = Profile()
    var id: Int?
    var profileImage: UIImage?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    fileprivate let baseUrl = "http://jsonplaceholder.typicode.com/users/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 90
        
        if let id = self.id {
            let url = baseUrl.appending("\(id)")
            WebserviceManager().callWebservice(for: url, completionHandler: { (responseDict) in
                self.profile?.setValuesForKeys(responseDict as! [String : Any])
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return self.profile?.address?.keys.count ?? 1
        }
        return self.profile?.company?.keys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameCell
            if let profile = self.profile {
                if let name = profile.name, let contact = profile.phone, let email = profile.email  {
                    cell.configureCell(with: name, contact: contact, email: email)
                }
                
                if let image = self.profileImage {
                    cell.cellImageView.image = image
                }
                
                
            }
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! DetailCell
            if let address = profile?.address {
                let key =  address.keys[indexPath.row]
                cell.titlesLabel?.text = key
                cell.detailLabel?.text = address.descriptiveAddress[key]
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! DetailCell
        if let company = profile?.company {
            let key = company.keys[indexPath.row]
            cell.titlesLabel.text = key
            cell.detailLabel?.text = company.descritiveDetail[key]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Address"
        }
        if section == 2 {
            return self.profile?.company?.headerName
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
}
