//
//  SoftwareSearchResponse.swift
//  API
//
//  Created by Cem Ege on 4.09.2023.
//

public struct SoftwareSearchResponse: Decodable {
    let resultCount: Int?
    let results: [SoftwareSearchResults]?
}

public struct SoftwareSearchResults: Decodable {
    let artworkUrl512: String?
    let artworkUrl100: String?
    let artworkUrl60: String?
    let artistViewUrl: String?
    let screenshotUrls: [String]?
    let ipadScreenshotUrls: [String]?
    let appletvScreenshotUrls: [String]?
    let isGameCenterEnabled: Bool?
    let supportedDevices: [String]?
    let features: [String]?
    let advisories: [String]?
    let kind: String?
    let trackCensoredName: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes: String?
    let sellerUrl: String?
    let formattedPrice: String?
    let contentAdvisoryRating: String?
    let averageUserRatingForCurrentVersion: Double?
    let userRatingCountForCurrentVersion: Int?
    let averageUserRating: Double?
    let trackViewUrl: String?
    let trackContentRating: String?
    let minimumOsVersion: String?
    let currentVersionReleaseDate: String?
    let releaseNotes: String?
    let artistId: Int?
    let artistName: String?
    let genres: [String]?
    let price: Double?
    let description: String?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let bundleId: String?
    let trackId: Int?
    let trackName: String?
    let releaseDate: String?
    let primaryGenreName: String?
    let primaryGenreId: Int?
    let genreIds: [String]?
    let sellerName: String?
    let currency: String?
    let version: String?
    let wrapperType: String?
    let userRatingCount: Int?
}
