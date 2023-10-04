import Foundation

struct AmberApi {
  let key: String
}


class AmberApiManager {
  static let shared  = AmberApiManager()
  private var mockApi: AmberApi = AmberApi(key: "test1234")
}

