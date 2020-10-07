//
//  EntryDetailViewController.swift
//  JournalCloudKit
//
//  Created by Trevor Bursach on 10/5/20.
//

import UIKit

class EntryDetailViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var entryTitleTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    
    //MARK: - Properties
    
    var entry: Entry?

    override func viewDidLoad() {
        super.viewDidLoad()
        entryTitleTextField.delegate = self
        updateViews()
    }
    
    //MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = entryTitleTextField.text, !title.isEmpty,
              let body = entryBodyTextView.text, !body.isEmpty else { return }
        
        if let entry = entry {
            EntryController.shared.saveEntry(entry: entry) { (result) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            EntryController.shared.createEntryWith(title: title, body: body) { (result) in
                switch result {
                
                case .success(_):
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        entryTitleTextField.text = ""
        entryBodyTextView.text = ""
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        entryTitleTextField.resignFirstResponder()
        entryBodyTextView.resignFirstResponder()
    }
    
    func updateViews() {
        guard let entry = entry else { return }
        entryTitleTextField.text = entry.title
        entryBodyTextView.text = entry.body
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        entryTitleTextField.resignFirstResponder()
    }
    
} // END OF CLASS
