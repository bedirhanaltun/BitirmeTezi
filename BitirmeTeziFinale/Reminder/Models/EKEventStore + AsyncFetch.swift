//
//  EKEventStore + AsyncFetch.swift
//  BitirmeTeziFinale
//
//  Created by Bedirhan Altun on 19.05.2023.
//

import Foundation
import EventKit

extension EKEventStore {
  
  func fetchReminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
    try await withCheckedThrowingContinuation { continuation in
      fetchReminders(matching: predicate) { reminders in
        if let reminders = reminders {
          continuation.resume(returning: reminders)
        } else {
          continuation.resume(throwing: TodayError.failedReadingReminders)
        }
      }
    }
  }
  
}
