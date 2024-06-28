//
//  UploadPictureView.swift
//  FlickerSearch
//
//  Created by Bhat, Rohit on 6/21/24.
//

import SwiftUI
import OAuthSwift

struct UploadPictureView: View {
    
    @StateObject var viewModel = UploadPictureViewModel()
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 20) {
                if viewModel.showSpinner {
                    ProgressView()
                } else {
                    if viewModel.postImageFailed == false {
                        SuccessView(config: HUDConfig.success("Upload Done"), complete: {
                            viewModel.pickedImage = nil
                            viewModel.postImageFailed = nil
                        })
                    } else {
                        DescriptionText(title: viewModel.pickedImage == nil ? "Please Select an Image for Upload" : "")
                            .opacity(viewModel.pickedImage == nil ? 1.0 : 0.0)
                        Button {
                            viewModel.openCameraSheet.toggle()
                        } label: {
                            Group {
                                ZStack(alignment: .bottomTrailing) {
                                    if let pickedImage = viewModel.pickedImage {
                                        Image(uiImage: pickedImage)
                                            .profileImageModifier()
                                    } else {
                                        Image(systemName: "photo")
                                            .profileImageModifier()
                                    }
                                    
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .sheet(isPresented: $viewModel.openCameraSheet, content: {
                            ImagePicker(selectedImage: $viewModel.pickedImage)
                        })
                        
                        Button {
                            viewModel.doService()
                        } label: {
                            ButtonView(title: "Upload Picture")
                        }
                        .disabled(viewModel.pickedImage == nil ? true : false)
                        .padding()
                    }
                }
            }
            .navigationTitle("Upload picture")
        }
    }
}

struct UploadPictureView_Previews: PreviewProvider {
    static var previews: some View {
        UploadPictureView()
    }
}
