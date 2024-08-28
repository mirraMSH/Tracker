//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Мария Шагина on 19.08.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    
    var trackerRecordsCoreData: [TrackerRecordCoreData] {
        let fetchedRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        guard let objects = try? context.fetch(fetchedRequest) else { return [] }
        return objects
    }
    
    private struct TrackerRecordStoreConstants {
        static let entityName = "TrackerCoreData"
        static let categorySectionNameKeyPath = "category"
    }
    
    private enum TrackerRecordStoreError: Error {
        case errorDecodingDate
    }
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    func saveRecord(for trackerCoreData: TrackerCoreData, with date: Date) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.tracker = trackerCoreData
        trackerRecordCoreData.date = date
        saveContext()
    }
    
    func removeRecord(for trackerCoreData: TrackerCoreData, with date: Date) {
        trackerRecordsCoreData.forEach { trackerRecordCoreData in
            guard trackerRecordCoreData.tracker == trackerCoreData,
                  trackerRecordCoreData.date == date else { return }
            context.delete(trackerRecordCoreData)
            saveContext()
        }
    }
    
    func checkDate(from trackerCoreData: TrackerCoreData, with date: Date) -> Bool {
        let fetchedRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        fetchedRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.date), date as NSDate)
        
        guard let objects = try? context.fetch(fetchedRequest) else { return false }
        
        return objects.contains { $0.tracker == trackerCoreData }
    }
    
    
    func getRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let date = trackerRecordCoreData.date else { throw TrackerRecordStoreError.errorDecodingDate }
        return TrackerRecord(checkDate: date)
    }
    
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
