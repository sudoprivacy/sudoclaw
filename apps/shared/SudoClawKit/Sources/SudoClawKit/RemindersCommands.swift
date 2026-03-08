import Foundation

public enum SudoClawRemindersCommand: String, Codable, Sendable {
    case list = "reminders.list"
    case add = "reminders.add"
}

public enum SudoClawReminderStatusFilter: String, Codable, Sendable {
    case incomplete
    case completed
    case all
}

public struct SudoClawRemindersListParams: Codable, Sendable, Equatable {
    public var status: SudoClawReminderStatusFilter?
    public var limit: Int?

    public init(status: SudoClawReminderStatusFilter? = nil, limit: Int? = nil) {
        self.status = status
        self.limit = limit
    }
}

public struct SudoClawRemindersAddParams: Codable, Sendable, Equatable {
    public var title: String
    public var dueISO: String?
    public var notes: String?
    public var listId: String?
    public var listName: String?

    public init(
        title: String,
        dueISO: String? = nil,
        notes: String? = nil,
        listId: String? = nil,
        listName: String? = nil)
    {
        self.title = title
        self.dueISO = dueISO
        self.notes = notes
        self.listId = listId
        self.listName = listName
    }
}

public struct SudoClawReminderPayload: Codable, Sendable, Equatable {
    public var identifier: String
    public var title: String
    public var dueISO: String?
    public var completed: Bool
    public var listName: String?

    public init(
        identifier: String,
        title: String,
        dueISO: String? = nil,
        completed: Bool,
        listName: String? = nil)
    {
        self.identifier = identifier
        self.title = title
        self.dueISO = dueISO
        self.completed = completed
        self.listName = listName
    }
}

public struct SudoClawRemindersListPayload: Codable, Sendable, Equatable {
    public var reminders: [SudoClawReminderPayload]

    public init(reminders: [SudoClawReminderPayload]) {
        self.reminders = reminders
    }
}

public struct SudoClawRemindersAddPayload: Codable, Sendable, Equatable {
    public var reminder: SudoClawReminderPayload

    public init(reminder: SudoClawReminderPayload) {
        self.reminder = reminder
    }
}
