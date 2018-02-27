//
//  ForgotPasswordViewModelSpec.swift
//  ShopAppTests
//
//  Created by Radyslav Krechet on 2/26/18.
//  Copyright © 2018 RubyGarage. All rights reserved.
//

import Nimble
import Quick
import RxSwift

@testable import ShopApp

class ForgotPasswordViewModelSpec: QuickSpec {
    override func spec() {
        let repositoryMock = AuthentificationRepositoryMock()
        let resetPasswordUseCaseMock = ResetPasswordUseCaseMock(repository: repositoryMock)
        
        var viewModel: ForgotPasswordViewModel!
        
        beforeEach {
            viewModel = ForgotPasswordViewModel(resetPasswordUseCase: resetPasswordUseCaseMock)
        }
        
        describe("when view model initialized") {
            it("should have variable with a correct initial value") {
                expect(viewModel.emailText.value) == ""
            }
        }
        
        describe("when email text changed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            context("if it have at least one symbol in text variable") {
                it("needs to enable forgot password button") {
                    viewModel.emailText.value = "u"
                    
                    viewModel.resetPasswordButtonEnabled
                        .subscribe(onNext: { enabled in
                            expect(enabled) == true
                        })
                        .disposed(by: disposeBag)
                }
            }
            
            context("if it doesn't have symbols in text variables") {
                it("needs to disable forgot password button") {
                    viewModel.emailText.value = ""
                    
                    viewModel.resetPasswordButtonEnabled
                        .subscribe(onNext: { enabled in
                            expect(enabled) == false
                        })
                        .disposed(by: disposeBag)
                }
            }
        }
        
        describe("when forgot password button pressed") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
                
                viewModel.emailText.value = "user@mail.com"
            }
            
            context("if it have not valid email text") {
                it("needs to show error messages about not valid email text") {
                    viewModel.emailText.value = "user@mail"
                    
                    viewModel.emailErrorMessage
                        .subscribe(onNext: { errorMessage in
                            expect(errorMessage).toEventually(equal("Error.InvalidEmail".localizable))
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.resetPasswordPressed.onNext()
                }
            }
            
            context("if it have valid email text and success reset password") {
                it("needs to dismiss view controller") {
                    viewModel.resetPasswordSuccess
                        .subscribe(onNext: { success in
                            expect(success).toEventually(beTrue())
                        })
                        .disposed(by: disposeBag)
                    
                    viewModel.resetPasswordPressed.onNext()
                }
            }
        }
        
        describe("when try again and it have valid email text and success reset password") {
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
                
                viewModel.emailText.value = "user@mail.com"
            }
            
            it("needs to dismiss view controller") {
                viewModel.resetPasswordSuccess
                    .subscribe(onNext: { success in
                        expect(success).toEventually(beTrue())
                    })
                    .disposed(by: disposeBag)
                
                viewModel.tryAgain()
            }
        }
    }
}