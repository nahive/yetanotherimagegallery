//
//  PhotoSpec.swift
//  yetanotherimagegallery
//
//  Created by Szymon Maślanka on 18/05/2017.
//  Copyright © 2017 Szymon Maślanka. All rights reserved.
//

import XCTest
import Quick
import Nimble

@testable import yetanotherimagegallery

class PhotoSpec: QuickSpec {
    
    // MARK: ViewMock
    
    class PhotoViewMock: PhotoViewType {
        var presenter: PhotoPresenterType!
        
        var wasMessagePresented = false
        var wasMessageSuccess = false
        
        func present(message: String) {
            wasMessagePresented = true
            // I know it should be const string, or even better localized.
            // But here it's just for testing example app purposes, so..
            if message == "Photo was saved in library" {
                wasMessageSuccess = true
            }
        }
    }
    
    override func spec() {
        photoSpec()
    }
    
    // MARK: photo tests
    private func photoSpec() {
        var view: PhotoViewMock!
        var workflow: MainWorkflowMock!
        var presenter: PhotoPresenter!
        
        describe("PhotoPresenter workflow tests") {
            context("open share fail") {
                beforeEach {
                    view = PhotoViewMock()
                    workflow = MainWorkflowMock()
                    presenter = PhotoPresenter(view: view, workflow: workflow)
                    presenter.share(photo: nil)
                }
                
                it("should succeed") {
                    expect(workflow.wasSharePresented) == false
                    expect(view.wasMessagePresented) == true
                    expect(view.wasMessageSuccess) == false
                }
            }
            
            context("open share valid") {
                beforeEach {
                    view = PhotoViewMock()
                    workflow = MainWorkflowMock()
                    presenter = PhotoPresenter(view: view, workflow: workflow)
                    presenter.share(photo: #imageLiteral(resourceName: "test_photo"))
                }
                
                it("should succeed") {
                    expect(workflow.wasSharePresented) == true
                    // no message on success here
                }
            }
            
            context("save photo empty") {
                beforeEach {
                    view = PhotoViewMock()
                    workflow = MainWorkflowMock()
                    presenter = PhotoPresenter(view: view, workflow: workflow)
                    presenter.save(photo: nil)
                }
                
                it("should fail") {
                    expect(view.wasMessagePresented) == true
                    expect(view.wasMessageSuccess) == false
                }
            }
            
            context("save photo valid") {
                beforeEach {
                    view = PhotoViewMock()
                    workflow = MainWorkflowMock()
                    presenter = PhotoPresenter(view: view, workflow: workflow)
                    presenter.save(photo: #imageLiteral(resourceName: "test_photo"))
                }
                
                it("should succeed") {
                    expect(view.wasMessagePresented).toEventually(beTrue())
                    expect(view.wasMessageSuccess).toEventually(beTrue())
                }
            }
        }
    }
}
