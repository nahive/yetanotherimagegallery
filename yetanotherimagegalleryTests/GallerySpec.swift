//
//  GallerySpec.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 18/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import yetanotherimagegallery

class GallerySpec: QuickSpec {
    
    // MARK: ViewMock
    
    class GalleryViewMock: GalleryViewType {
        
        var presenter: GalleryPresenterType!
        
        var werePhotosPresented = false
        var wasErrorPresented = false
        
        func presentPhotos() {
            werePhotosPresented = true
        }
        
        func present(error: String) {
            wasErrorPresented = true
        }
        
        func presentIndicator() { }
        func hideIndicator() { }
    }
    
    override func spec() {
        mockedServiceSpec()
//        realServiceSpec()
        presenterSpec()
    }
    
    //MARK: mocked service tests
    private func mockedServiceSpec() {
        var view: GalleryViewMock!
        var service: FlickrServiceMock!
        var workflow: MainWorkflowMock!
        var presenter: GalleryPresenter!
        
        describe("GalleryPresenter Mocked Service") {
            context("wrong call") {
                beforeEach {
                    view = GalleryViewMock()
                    service = FlickrServiceMock(baseURLString: "random")
                    workflow = MainWorkflowMock()
                    presenter = GalleryPresenter(view: view, service: service, workflow: workflow)
                    service.shouldCallSucceed = false
                    presenter.fetchPhotos(tags: nil)
                }
                
                it("should present error") {
                    expect(service.wasServiceCalled) == true
                    expect(view.wasErrorPresented) == true
                    expect(view.werePhotosPresented) == false
                }
            }
            
            context("valid call") {
                beforeEach {
                    view = GalleryViewMock()
                    service = FlickrServiceMock(baseURLString: "random")
                    workflow = MainWorkflowMock()
                    presenter = GalleryPresenter(view: view, service: service, workflow: workflow)
                    service.shouldCallSucceed = true
                    presenter.fetchPhotos(tags: nil)
                }
                
                it("should succeed") {
                    expect(service.wasServiceCalled) == true
                    expect(view.wasErrorPresented) == false
                    expect(view.werePhotosPresented) == true
                }
            }
            
            context("valid call with tag") {
                beforeEach {
                    view = GalleryViewMock()
                    service = FlickrServiceMock(baseURLString: "random")
                    workflow = MainWorkflowMock()
                    presenter = GalleryPresenter(view: view, service: service, workflow: workflow)
                    service.shouldCallSucceed = true
                    presenter.fetchPhotos(tags: "dog")
                }
                
                it("should succeed") {
                    expect(service.wasServiceCalled) == true
                    expect(view.wasErrorPresented) == false
                    expect(view.werePhotosPresented) == true
                }
            }
        }
    }
    
    //MARK: real service tests
    private func realServiceSpec() {
        var view: GalleryViewMock!
        var service: FlickrService!
        var workflow: MainWorkflowMock!
        var presenter: GalleryPresenter!
        
        describe("GalleryPresenter Real Service") {
            context("wrong url") {
                beforeEach {
                    view = GalleryViewMock()
                    service = FlickrService(baseURLString: "https://api.flickr.comtest")
                    workflow = MainWorkflowMock()
                    presenter = GalleryPresenter(view: view, service: service, workflow: workflow)
                    presenter.fetchPhotos(tags: nil)
                }
                
                it("should present error") {
                    expect(view.wasErrorPresented).toEventually(beTrue())
                    expect(view.werePhotosPresented).toEventually(beFalse())
                }
            }
            
            context("valid call") {
                beforeEach {
                    view = GalleryViewMock()
                    service = FlickrService(baseURLString: "https://api.flickr.com")
                    workflow = MainWorkflowMock()
                    presenter = GalleryPresenter(view: view, service: service, workflow: workflow)
                    presenter.fetchPhotos(tags: nil)
                }
                
                it("should succeed") {
                    expect(view.wasErrorPresented).toEventually(beFalse())
                    expect(view.werePhotosPresented).toEventually(beTrue())
                }
            }
            
            context("valid call with tag") {
                beforeEach {
                    view = GalleryViewMock()
                    service = FlickrService(baseURLString: "https://api.flickr.com")
                    workflow = MainWorkflowMock()
                    presenter = GalleryPresenter(view: view, service: service, workflow: workflow)
                    presenter.fetchPhotos(tags: "test")
                }
                
                it("should succeed") {
                    expect(view.wasErrorPresented).toEventually(beFalse())
                    expect(view.werePhotosPresented).toEventually(beTrue())
                }
            }
        }
    }
    
    // MARK: workflow tests
    private func presenterSpec() {
        var view: GalleryViewMock!
        var service: FlickrServiceMock!
        var workflow: MainWorkflowMock!
        var presenter: GalleryPresenter!
        
        describe("GalleryPresenter Presenter") {
            context("present photo") {
                beforeEach {
                    view = GalleryViewMock()
                    service = FlickrServiceMock(baseURLString: "random")
                    workflow = MainWorkflowMock()
                    presenter = GalleryPresenter(view: view, service: service, workflow: workflow)
                    service.shouldCallSucceed = true
                    presenter.fetchPhotos(tags: nil)
                    presenter.presentPhoto(at: IndexPath(row: 0, section: 0))
                }
                
                it("should succeed") {
                    expect(service.wasServiceCalled) == true
                    expect(view.wasErrorPresented) == false
                    expect(view.werePhotosPresented) == true
                    expect(workflow.wasPhotoPresented) == true
                }
            }
            
            context("sort photos") {
                beforeEach {
                    view = GalleryViewMock()
                    service = FlickrServiceMock(baseURLString: "random")
                    workflow = MainWorkflowMock()
                    presenter = GalleryPresenter(view: view, service: service, workflow: workflow)
                    service.shouldCallSucceed = true
                    presenter.fetchPhotos(tags: nil)
                    presenter.sortPhotos(by: .taken, options: .ascending)
                }
                
                it("should succeed") {
                    expect(service.wasServiceCalled) == true
                    expect(view.wasErrorPresented) == false
                    expect(view.werePhotosPresented) == true
                }
            }
        }
    }
}
