import Foundation

struct TodoItem: Codable {
    var id: String = UUID().uuidString
    var title: String
    var isDone: Bool
    var alarmDate: Date?
}
