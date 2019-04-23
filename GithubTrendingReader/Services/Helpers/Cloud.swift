//
//  Cloud.swift
//  GithubTrendingReader
//
//  Created by Laurent Grondin on 23/04/2019.
//  Copyright © 2019 Laurent Grondin. All rights reserved.
//

import Foundation
import CloudKit

// MARK: - Cloud class

class Cloud {
    var record: CKRecord?
}

/* Exemple
class Exemple: Cloud & Codable {}
*/

// MARK: - Enum

enum CloudError: Error {
    case noRecord
    case notCloudType
}

// MARK: - Extensions
// MARK: - Codable

extension Encodable {
    
    static var stringClass: String { return "\(self)" }

    var newRecord: CKRecord? {
        let record = CKRecord.init(recordType: Self.stringClass)
        guard let value: String = self.string() else { return nil }
        record["value"] = value
        return record
    }

    func saveInCloud() {
        guard let cloud = self as? Cloud, let record = cloud.record ?? self.newRecord else { return }
        let database = CKContainer.default().privateCloudDatabase
        database.save(record) { (record, error) in
            if let error = error { log_error(error.localizedDescription); return }
            log_info("\(Self.stringClass) saved in Cloud")
            guard let record = record else { log_error(CloudError.noRecord.localizedDescription); return }
            guard let cloud = self as? Cloud else { log_error(CloudError.notCloudType.localizedDescription); return }
            cloud.record = record
        }
    }
    
    func updateInCloud() {
        guard let cloud = self as? Cloud, let record = cloud.record else { return }
        let database = CKContainer.default().privateCloudDatabase
        database.save(record) { (record, error) in
            if let error = error { log_error(error.localizedDescription); return }
            log_info("\(Self.stringClass) updated in Cloud")
            guard let record = record else { log_error(CloudError.noRecord.localizedDescription); return }
            cloud.record = record
        }
    }
}

extension Decodable {
    
    static var stringClass: String { return "\(self)" }

    static func retrieveFromCloud(completion: @escaping ResultCompletion<[Self]>) {
        let query = CKQuery.init(recordType: stringClass, predicate: NSPredicate.init(value: true))
        query.sortDescriptors = [NSSortDescriptor.init(key: "modificationDate", ascending: false)]
        let database = CKContainer.default().privateCloudDatabase
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error { completion(.failure(error)); return }
            guard let records = records else { return }
            let result: [Self] = records.compactMap({ $0.toModel() })
            log_info("\(result.count) \(stringClass)")
            completion(.success(result))
        }
    }

    func removeFromCloud() {
        guard let cloud = self as? Cloud, let recordId = cloud.record?.recordID else { return }
        let database = CKContainer.default().privateCloudDatabase
        database.delete(withRecordID: recordId) { _, error in
            guard let error = error else { log_info("\(Self.stringClass) removed from Cloud"); return }
            log_error(error.localizedDescription)
        }
    }
}

// MARK: - CloudKit

extension CKRecord {
    
    func toModel<T: Decodable>() -> T? {
        guard let value  = self.value(forKey: "value") as? String, let data = value.data(using: String.Encoding.utf8) else { return nil }
        guard let result = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        guard let cloud  = result as? Cloud else { return result }
        cloud.record     = self
        return result
    }
}
