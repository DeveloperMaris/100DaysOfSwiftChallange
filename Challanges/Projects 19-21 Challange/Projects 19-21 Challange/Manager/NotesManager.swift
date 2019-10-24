//
//  NotesManager.swift
//  Projects 19-21 Challange
//
//  Created by Maris Lagzdins on 24/10/2019.
//  Copyright © 2019 Developer Maris. All rights reserved.
//

import Foundation

class NotesManager {
    private let database: Database
    private let queue: DispatchQueue
    private var unsafeNotes: [Note] = []

    init(database: Database) {
        self.database = database
        queue = DispatchQueue(label: "com.developermaris.Projects-19-21-Challange.NotesManager", qos: .userInitiated, attributes: .concurrent)
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            self.unsafeNotes = self.unsafeLoad()
        }
    }

    func loadNotes() -> [Note] {
        var result = [Note]()
        queue.sync {
            result = unsafeNotes
        }
        return result
    }

    func add(_ note: Note) {
        queue.async(flags: .barrier) { [weak self] in
            self?.unsafeNotes.append(note)
            self?.save()
        }
    }

    func update(_ note: Note) {
        queue.async(flags: .barrier) { [weak self] in
            if let index = self?.unsafeNotes.firstIndex(of: note) {
                self?.unsafeNotes[index] = note
                self?.save()
            }
        }
    }

    func remove(_ note: Note) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }

            self.unsafeNotes = self.unsafeNotes.filter { $0 != note }
            self.save()
        }
    }
}

private extension NotesManager {
    func unsafeLoad() -> [Note] {
        dispatchPrecondition(condition: .onQueue(queue))
        let data = database.load()

        if let notesData = data {
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode([Note].self, from: notesData) {
                return decodedData
            }
        }

        return []
    }

    func save() {
        dispatchPrecondition(condition: .onQueueAsBarrier(queue))
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(unsafeNotes) {
            database.save(data)
        }
    }
}
