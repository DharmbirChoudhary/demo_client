//
//  DemoTests.swift
//  DemoTests
//
//  Created by Dharmbir Singh on 07/06/26.
//

import XCTest
@testable import Demo

@MainActor
final class DemoTests: XCTestCase {

    private var sut: JobListViewModel!
    private var mockService: MockJobService!
    
    override func setUp() {
        super.setUp()
        mockService = MockJobService()
        sut = JobListViewModel(jobService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func test_loadJobs_success_setsLoadedState() async {
        // Given
        mockService.shouldReturnError = false
        
        // When
        await sut.loadJobs()
        
        // Then
        XCTAssertEqual(sut.state, .loaded)
        XCTAssertEqual(sut.filteredJobs.count, 3)
    }
    
    func test_loadJobs_failure_setsErrorState() async {
        // Given
        mockService.shouldReturnError = true
        
        // When
        await sut.loadJobs()
        
        // Then
        if case .error(let string) = sut.state {
            XCTAssertFalse(string.isEmpty)
        } else {
            XCTFail("Expected ViewModel to fall back to an .error state representation.")
        }
    }
    
    func test_searchFilter_matchesTitlesAndCompanies() async {
        // Given
        await sut.loadJobs()
        
        // When matching Title matching criteria
        sut.searchText = "iOS"
        XCTAssertEqual(sut.filteredJobs.count, 1)
        XCTAssertEqual(sut.filteredJobs.first?.companyName, "TechCorp")
        
        // When matching Company string patterns
        sut.searchText = "vNext"
        XCTAssertEqual(sut.filteredJobs.count, 1)
        XCTAssertEqual(sut.filteredJobs.first?.title, "Staff Swift Developer")
        
        // When search data contains an empty set match
        sut.searchText = "InvalidSearchQueryPattern"
        XCTAssertTrue(sut.filteredJobs.isEmpty)
    }

}
