import Foundation

struct HospitalRecord: Codable {
    let date: Date
    let hospitalName: String
    let vaccination: Bool
    let memo: String
}
