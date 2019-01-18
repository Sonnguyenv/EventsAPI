
import UIKit

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

class ViewController: UIViewController {
    @IBOutlet weak var eventLable: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var nameVanueLable: UILabel!
    @IBOutlet weak var contactAddressVanueLable: UILabel!
    @IBOutlet weak var geoAreaVanueLable: UILabel!
    
    @IBOutlet weak var startDateLable: UILabel!
    @IBOutlet weak var startTimeLable: UILabel!
    @IBOutlet weak var endDateLable: UILabel!
    @IBOutlet weak var endTimeLable: UILabel!
    
    @IBOutlet weak var descriptionrawLable: UILabel!
    @IBOutlet weak var descriptionhtmlLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: "http://172.16.18.91/18175d1_mobile_100_fresher/public/api/v0/getDetailEvent?event_id=1") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {print(data)
                let noname = try JSONDecoder().decode(Noname.self, from: data)
                let dataEvents = noname.response?.events
                let dataVanue = noname.response?.events?.venue
                let dataCategory = noname.response?.events?.category
                print(dataCategory?.name ?? "")
                let imageUrl = URL(string: noname.response?.events?.photo ?? "")
                URLSession.shared.dataTask(with: imageUrl!) { (data, response, error) in
                    if error == nil {
                        let loadedImage = UIImage(data: data!)
                        DispatchQueue.main.async {
                            // events
                            self.eventImage.image = loadedImage
                            self.eventLable.text = dataEvents?.name
                            self.descriptionrawLable.text = dataEvents?.description_raw?.htmlToString
//                            self.descriptionhtmlLable.text = dataEvents?.description_html?.htmlToString
                            self.startDateLable.text = dataEvents?.schedule_start_date
                            self.startTimeLable.text = dataEvents?.schedule_start_time
                            self.endDateLable.text = dataEvents?.schedule_end_date
                            self.endTimeLable.text = dataEvents?.schedule_end_time
                            // vanue
                            self.nameVanueLable.text = dataVanue?.name
                            self.contactAddressVanueLable.text = dataVanue?.contact_address
                            self.geoAreaVanueLable.text = dataVanue?.geo_area
                            
                        }
                    }
                }.resume()
            } catch {}
        }.resume()
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
