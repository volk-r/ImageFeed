//
//  String+Extensions.swift
//  ImageFeed
//
//  Created by Roman Romanov on 28.07.2024.
//

import Foundation

extension String {
    var convertISOStringToDate: Date? { formatISOStringToDate(self) }
    
    private func formatISOStringToDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)
    }
}
