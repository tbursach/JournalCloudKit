//
//  EntryListTableViewController.swift
//  JournalCloudKit
//
//  Created by Trevor Bursach on 10/5/20.
//

import UIKit

class EntryListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        EntryController.shared.fetchEntriesWith { (result) in
            self.updateViews()
        }
    }

    //MARK: - Actions
    
    @IBAction func addEntryButtonTapped(_ sender: Any) {
        
    }
    
    func updateViews() {
        DispatchQueue.main.async {            
        self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entryToDisplay = EntryController.shared.entries[indexPath.row]
        cell.textLabel?.text = entryToDisplay.title
        cell.detailTextLabel?.text = entryToDisplay.timestamp.formatDate()
        

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? EntryDetailViewController else { return }
            
            let selectedEntry = EntryController.shared.entries[indexPath.row]
            destination.entry = selectedEntry
            
        }
        
    }

} // END OF CLASS
