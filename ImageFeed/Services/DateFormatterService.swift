//
//  DateFormatterService.swift
//  ImageFeed
//
//  Created by Roman Romanov on 07.08.2024.
//

import Foundation

final class DateFormatterService {
    static let shared = DateFormatterService()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private lazy var formatterISO = ISO8601DateFormatter()
    
    private init() { }
    
    func formatISOStringToDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        
        return formatterISO.date(from: dateString)
    }
    
    func stringFromDate(_ date: Date?) -> String? {
        guard let date = date else {
            return nil
        }
        return dateFormatter.string(from: date)
    }
}
