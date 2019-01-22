
import Foundation

struct Noname: Decodable {
    let status: Int
    let response: Response?
}

struct Response: Decodable {
    let events: Events?
}

struct Events: Decodable {
    let id: Int?
    let status: Int?
    let link: String?
    let photo: String?
    let name: String?
    let description_raw: String?
    let description_html: String?
    let schedule_start_date: String
    let schedule_start_time: String
    let schedule_end_date: String
    let schedule_end_time: String
    let going_count: Int
    let went_count: Int
    let venue: Venue?
    let category: Category?
}

struct Venue: Decodable {
    let id: Int
    let name: String
    let type: Int
    let description: String
    let contact_phone: String
    let contact_address: String
    let geo_area: String
    let geo_long: String
    let geo_lat: String
}

struct Category: Decodable {
    let id: Int
    let name: String
    let slug: String
}
