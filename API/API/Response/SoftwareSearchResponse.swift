//
//  SoftwareSearchResponse.swift
//  API
//
//  Created by Cem Ege on 4.09.2023.
//

public struct SoftwareSearchResponse: Decodable {
    public let resultCount: Int?
    public let results: [SoftwareSearchResults]?
}

public struct SoftwareSearchResults: Decodable {
    public let artworkUrl512: String?
    public let artworkUrl100: String?
    public let artworkUrl60: String?
    public let artistViewUrl: String?
    public let screenshotUrls: [String]?
    public let ipadScreenshotUrls: [String]?
    public let appletvScreenshotUrls: [String]?
    public let isGameCenterEnabled: Bool?
    public let supportedDevices: [String]?
    public let features: [String]?
    public let advisories: [String]?
    public let kind: String?
    public let trackCensoredName: String?
    public let languageCodesISO2A: [String]?
    public let fileSizeBytes: String?
    public let sellerUrl: String?
    public let formattedPrice: String?
    public let contentAdvisoryRating: String?
    public let averageUserRatingForCurrentVersion: Double?
    public let userRatingCountForCurrentVersion: Int?
    public let averageUserRating: Double?
    public let trackViewUrl: String?
    public let trackContentRating: String?
    public let minimumOsVersion: String?
    public let currentVersionReleaseDate: String?
    public let releaseNotes: String?
    public let artistId: Int?
    public let artistName: String?
    public let genres: [String]?
    public let price: Double?
    public let description: String?
    public let isVppDeviceBasedLicensingEnabled: Bool?
    public let bundleId: String?
    public let trackId: Int?
    public let trackName: String?
    public let releaseDate: String?
    public let primaryGenreName: String?
    public let primaryGenreId: Int?
    public let genreIds: [String]?
    public let sellerName: String?
    public let currency: String?
    public let version: String?
    public let wrapperType: String?
    public let userRatingCount: Int?
}
