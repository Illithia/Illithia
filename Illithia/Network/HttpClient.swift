//
//  HttpClient.swift
//  Illithia
//
//  Created by Angelo Carasig on 18/8/2024.
//
import Foundation
import RealmSwift

@MainActor
struct HttpClient {
    func getManga(props: ListManga) async throws -> Manga? {
        guard let url = URL(string: "https://alethia-edge.alethia.workers.dev/mangadex/manga/\(props.slug)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        
        return ObjectMapper.MangaMapper(json: json)
    }
    
    func getRecent() async throws -> [ListManga] {
        guard let url = URL(string: "https://alethia-edge.alethia.workers.dev/mangadex/recent") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let mangaList = try JSONDecoder().decode([ListManga].self, from: data)
        
        return mangaList
    }
    
    func fetchManga(for repository: Repository, sourceItem: SourceItem, route: String) async throws -> [ListManga] {
        guard let url = URL(string: "\(repository.baseUrl)/\(sourceItem.name)/\(route)") else {
            throw URLError(.badURL)
        }
        
        print("Repository URL: ", repository.baseUrl)
        print("Source Item: ", sourceItem.name)
        print("Route: ", route)
        print("URL: ", url.absoluteString)
        
        // Make the network request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check the HTTP response status code
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Decode the JSON response into a list of manga objects
        let mangaList = try JSONDecoder().decode([ListManga].self, from: data)
        
        return mangaList
    }
    
    func addRepository(url: String) async throws -> Repository? {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw URLError(.cannotParseResponse)
        }
        
        guard let repositoryName = json["repository"] as? String,
              let sourcesArray = json["sources"] as? [String],
              !sourcesArray.isEmpty else {
            throw NSError(domain: "InvalidRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid repository data."])
        }
        
        let repository = Repository()
        repository.name = repositoryName
        repository.baseUrl = url.absoluteString
        
        for source in sourcesArray {
            let sourceURL = url.appendingPathComponent(source)
            
            // Validate the base source URL
            try await validateRoute(url: sourceURL)
            
            // Validate required routes
            let requiredRoutes = ["/manga", "/chapter", "/chapters"]
            for route in requiredRoutes {
                let routeURL = sourceURL.appendingPathComponent(route)
                try await validateRoute(url: routeURL)
            }
            
            // Fetch and validate custom routes, adding them to the routes list
            let routes = List<String>()
            let (customData, customResponse) = try await URLSession.shared.data(from: sourceURL) // No additional path appended
            
            guard let customHttpResponse = customResponse as? HTTPURLResponse, customHttpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            if let customJson = try JSONSerialization.jsonObject(with: customData, options: []) as? [String: Any],
               let customRoutes = customJson["routes"] as? [String] {
                for customRoute in customRoutes {
                    let customRouteURL = sourceURL.appendingPathComponent(customRoute)
                    try await validateRoute(url: customRouteURL)
                    routes.append(customRoute)
                }
            }
            
            let sourceItem = SourceItem()
            sourceItem.name = source
            sourceItem.routes = routes
            sourceItem.enabled = true
            
            repository.sources.append(sourceItem)
        }
        
        return repository
    }
    
    
    private func validateRoute(url: URL) async throws {
        let (_, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "InvalidRoute", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid route at \(url.absoluteString)"])
        }
    }
}

struct ObjectMapper {
    static func MangaMapper(json: [String: Any]?) -> Manga? {
        guard let json = json else {
            return nil
        }
        
        let manga = Manga()
        manga.id = json["slug"] as? String ?? UUID().uuidString
        manga.title = json["title"] as? String ?? ""
        manga.author = json["author"] as? String
        manga.artist = json["artist"] as? String
        manga.synopsis = json["synopsis"] as? String
        manga.coverUrl = json["coverUrl"] as? String
        manga.contentRating = json["contentRating"] as? String
        manga.contentStatus = json["contentStatus"] as? String
        
        if let alternativeTitles = json["alternativeTitles"] as? [String] {
            manga.alternativeTitles.append(objectsIn: alternativeTitles)
        }
        
        if let tags = json["tags"] as? [String] {
            manga.tags.append(objectsIn: tags)
        }
        
        let source = Source()
        source.id = UUID().uuidString
        source.sourceId = json["sourceId"] as? String ?? ""
        source.mangaId = manga.id
        source.slug = json["slug"] as? String
        source.url = json["url"] as? String
        
        if let updatedAtString = json["updatedAt"] as? String {
            source.updatedAt = dateFormatter().date(from: updatedAtString) ?? Date()
        } else {
            source.updatedAt = Date()
        }
        
        if let chaptersArray = json["chapters"] as? [[String: Any]] {
            for chapterData in chaptersArray {
                if let chapter = ChapterMapper(json: chapterData, sourceId: source.id, mangaSlug: source.slug ?? "") {
                    source.chapters.append(chapter)
                }
            }
        }
        
        manga.sources.append(source)
        
        return manga
    }
    
    static func ChapterMapper(json: [String: Any]?, sourceId: String, mangaSlug: String) -> Chapter? {
        guard let json = json else {
            return nil
        }
        
        let chapter = Chapter()
        chapter.slug = json["slug"] as? String ?? UUID().uuidString
        chapter.sourceId = sourceId
        chapter.mangaSlug = mangaSlug
        chapter.pages = json["pages"] as? Int ?? 0
        chapter.chapterNumber = json["chapterNumber"] as? Int ?? 0
        chapter.chapterTitle = json["chapterTitle"] as? String ?? ""
        chapter.author = json["author"] as? String ?? sourceId
        
        if let dateString = json["date"] as? String {
            chapter.date = dateFormatter().date(from: dateString) ?? Date()
        }
        
        return chapter
    }
    
    private static func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }
}
