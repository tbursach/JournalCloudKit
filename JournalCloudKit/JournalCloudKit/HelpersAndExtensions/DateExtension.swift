//
//  DateExtension.swift
//  JournalCloudKit
//
//  Created by Trevor Bursach on 10/5/20.
//

import Foundation

extension Date {
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
    
}
