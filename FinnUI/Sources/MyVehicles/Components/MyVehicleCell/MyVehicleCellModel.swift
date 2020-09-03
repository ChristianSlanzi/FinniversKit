public struct MyVehicleCellModel: Identifiable, Hashable {
    public var id: String
    public var imageUrl: String
    public var imagePath: String?
    public var title: String
    public var subtitle: String
    public var detail: String

    public init(
        id: String,
        imageUrl: String,
        imagePath: String?,
        title: String,
        subtitle: String,
        detail: String
    ) {
        self.id = id
        self.imageUrl = imageUrl
        self.imagePath = imagePath
        self.title = title
        self.subtitle = subtitle
        self.detail = detail
    }

    public func constructImageURL() -> URL? {
        guard
            let path = imagePath,
            let url = URL(string: "\(self.imageUrl)\(path)") else
        { return nil }
        return url
    }
}

extension MyVehicleCellModel {
    static var sampleData = MyVehicleCellModel(
        id: "\(228920)",
        imageUrl: "https://images.finncdn.no/dynamic/default/",
        imagePath: "2020/8/my_vehicles/20/1/228/921_745856010.jpg",
        title: "VOLKSWAGEN",
        subtitle: "DP70498",
        detail: "Frist for EU-godkjenning: 16.05.2021")
}
