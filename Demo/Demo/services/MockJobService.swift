// MARK: - Model

import Foundation

struct Job: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let companyName: String
    let location: String
    let salaryRange: String
    let description: String
    let companyInfo: String
}

// MARK: - API Service
final class MockJobService: JobServiceProtocol {
    var shouldReturnError = false
    
    func fetchJobs() async throws -> [Job] {
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1-second delay
        
        if shouldReturnError {
            throw URLError(.badServerResponse)
        }
        
        return [
            Job(id: "1", title: "Senior iOS Engineer", companyName: "TechCorp", location: "London, UK", salaryRange: "£85,000 - £100,000", description: "Build modern SwiftUI fintech applications.", companyInfo: "A global leading banking automation company."),
            Job(id: "2", title: "Product Designer", companyName: "Innovate Studio", location: "Remote", salaryRange: "£60,000 - £75,000", description: "Design next-gen design systems in Figma.", companyInfo: "Boutique design agency scaling digital products."),
            Job(id: "3", title: "Staff Swift Developer", companyName: "vNext Frameworks", location: "New York, USA", salaryRange: "$150,000 - $180,000", description: "Architect highly scalable framework architectures.", companyInfo: "Silicon Valley infrastructure unicorn.")
        ]
    }
}
