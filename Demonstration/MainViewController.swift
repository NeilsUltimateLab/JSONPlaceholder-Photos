//
//  MainViewController.swift
//  Demonstration
//
//  Created by Neil on 26/01/17.
//  Copyright © 2017 Neil's Ultimate Lab. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    var albums: [Album]? = [Album]()
    
    var filteredAlbums: [Album]? = [Album]()
    
    fileprivate let cellId = "cell"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 10
        
        self.clearsSelectionOnViewWillAppear = true
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["1","2"]
        searchController.searchBar.delegate = self
        
        // webservice call and it's response
        let urlString = "http://jsonplaceholder.typicode.com/photos"
        
        WebserviceManager().callWebservice(for: urlString) { (json) in
            self.tableView.isHidden = false
            self.albums?.removeAll()
            
            if let responseArray = json as? NSArray {
                for responseDic in responseArray {
                    if let responses = responseDic as? NSDictionary {
                        
                        var album = Album()
                        if let albumId = responses["albumId"] as? Int {
                            album.albumId = albumId
                        }
                        if let id = responses["id"] as? Int {
                            album.id = id
                        }
                        if let thumbUrl = responses["thumbnailUrl"] as? String {
                            album.thumbnailUrl = thumbUrl
                        }
                        if let title = responses["title"] as? String {
                            album.title = title
                        }
                        if let url = responses["url"] as? String {
                            album.url = url
                        }
                        self.albums?.append(album)
                    }
                }
                
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredAlbums?.count ?? 0
        }
        return albums?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchController.isActive && searchController.searchBar.text != ""  {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MainCell
            let imageUrl = filteredAlbums?[indexPath.row].thumbnailUrl
            let title = filteredAlbums?[indexPath.row].title
            cell.configureCell(image: imageUrl!, title: title!, indexPath: indexPath)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MainCell
        
        let imageUrl = albums?[indexPath.row].thumbnailUrl
        let title = albums?[indexPath.row].title
        cell.configureCell(image: imageUrl!, title: title!, indexPath: indexPath)

        return cell
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let sender = sender as? MainCell , let vc = segue.destination as? DetailViewController {
            vc.profileImage = sender.cellImageView.image
            if let index = tableView.indexPathForSelectedRow {
                if searchController.isActive {
                    vc.id = self.filteredAlbums?[index.row].id
                }else {
                    vc.id = self.albums?[index.row].id
                }
            }
        }
    }

}


extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func filterContent(for searchText: String, scope: String = "All") {
        self.filteredAlbums = albums?.filter({ (album) -> Bool in
            let categoryMatch = (scope == "All") || album.albumId == Int(scope)
            return categoryMatch && (album.title?.lowercased().contains(searchText.lowercased()))!
        })
        self.tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(for: searchController.searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContent(for: searchBar.text!, scope: (searchBar.scopeButtonTitles?[selectedScope])!)
    }
    
}
