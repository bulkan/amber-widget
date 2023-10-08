import Foundation
import SwiftUI

enum Status: Codable {
  case pending, active, closed
}

struct Channel: Codable {
  let identifier: String
  let type: String
  let tariff: String
}

struct Site: Codable {
  let id: String
  let nmi: String
  let channels: [Channel]
  let status: String
  let network: String
  let activeFrom: String
}

struct CurrentInterval: Codable {
  let type: String
  let date: String
  let duration: Int
  let startTime: String
  let endTime: String
  let nemTime: String
  let perKwh: Float
  let renewables: Float
  let spotPerKwh: Float
  let channelType: String
  let spikeStatus: String
  let descriptor: String
  let estimate: Bool
}

enum AmberApiError: Error {
  // throws when there is no apiKey
  case noApiKey
  
  // Throw when URL generation fails
  case invalidUrl
  
  case invalidData
  case noSiteId
}

class AmberApi {
  private var endPoint = "https://api.amber.com.au/v1"
  
  @AppStorage("apiKey", store: UserDefaults(suiteName: "group.dev.bulkan.api")) private var apiKey = ""
  @AppStorage("siteId", store: UserDefaults(suiteName: "group.dev.bulkan.api")) private var siteId = ""

  func getSites() async throws -> Site? {
    if apiKey.isEmpty {
      throw AmberApiError.noApiKey
    }
    
    guard let url = URL(string: "\(endPoint)/sites") else { throw AmberApiError.invalidUrl }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    do {
      let decoder = JSONDecoder()
      return try decoder.decode([Site].self, from: data).first
    } catch {
      print(error)
      throw AmberApiError.invalidData
    }
  }
  
  func getCurrentSitePrice() async throws -> CurrentInterval? {
    if apiKey.isEmpty {
      throw AmberApiError.noApiKey
    }
    
    if (siteId.isEmpty) {
      let site = try await self.getSites()
      siteId = site?.id ?? ""
    }
    
    guard let url = URL(string: "\(endPoint)/sites/\(siteId)/prices/current?resolution=30") else { throw AmberApiError.invalidUrl }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    do {
      let decoder = JSONDecoder()
      return try decoder.decode([CurrentInterval].self, from: data).first
    } catch {
      print(error)
      throw AmberApiError.invalidData
    }
  }
  
  
}
