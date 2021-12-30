//
//  ImagePickerButton.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 12/12/2021.
//

import SwiftUI

struct ImagePickerButton: View {
    struct SheetState {
        var isVisible: Bool = false
        var visibleScreen: VisibleScreen = .albumPicker
        
        enum VisibleScreen {
            case albumPicker
            case cameraPicker
        }
    }
    
    @State private var isShowingOptions = false
    @State private var sheetState = SheetState()
    @State private var isShowingImageDeletionAlert = false
    @Binding var images: [UIImage]
    
    var body: some View {
        Button(action: {
            isShowingOptions = true
        }, label: {
            ZStack {
                Color("launch_color").frame(minHeight: 160, maxHeight: 160, alignment: .center)
                VStack(alignment: .leading, spacing: 24) {
                    if images.count > 0 {
                        Text("image-picker-add".localized).foregroundColor(.white).fontWeight(.regular)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(images, id: \.self) { image in
                                    Image(uiImage: image).resizable().frame(width: 48, height: 48, alignment: .center).clipShape(RoundedRectangle(cornerRadius: 4))
                                        .onTapGesture(perform: { isShowingImageDeletionAlert = true })
                                        .alert("image-picker-delete-alert".localized, isPresented: $isShowingImageDeletionAlert) {
                                            Button("image-picker-delete".localized, role: .destructive) {
                                                images = images.filter({ $0.pngData() != image.pngData() })
                                            }
                                            Button("image-picker-cancel".localized, role: .cancel) {}
                                        }
                                }
                                
                                ZStack {
                                    Color(red: 126/255, green: 126/255, blue: 114/255).frame(width: 48, height: 48, alignment: .center).clipShape(RoundedRectangle(cornerRadius: 4))
                                    Image(systemName: "plus").resizable().frame(width: 18, height: 18, alignment: .center).foregroundColor(Color(red: 243/255, green: 243/255, blue: 204/255))
                                }.onTapGesture(perform: { isShowingOptions = true })
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "plus.circle").resizable().frame(width: 36, height: 36, alignment: .center).foregroundColor(.white)
                            
                            Text("image-picker-add".localized).foregroundColor(.white).fontWeight(.semibold)
                        }
                    }
                }.padding()
            }
        })
            .aspectRatio(contentMode: .fill)
            .listRowInsets(EdgeInsets())
            .actionSheet(isPresented: $isShowingOptions) {
                let cameraButton: Alert.Button = {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        return Alert.Button.default(Text("image-picker-take-photo".localized)) {
                            sheetState.isVisible = true
                            sheetState.visibleScreen = .cameraPicker
                        }
                    } else {
                        return Alert.Button.destructive(Text("image-picker-camera-not-available".localized))
                    }
                }()
                
                return ActionSheet(
                    title: Text("image-picker-choose".localized),
                    buttons: [
                        cameraButton,
                        .default(Text("image-picker-add-library".localized)) {
                            sheetState.isVisible = true
                            sheetState.visibleScreen = .albumPicker
                        },
                        .cancel(Text("image-picker-cancel".localized))
                    ]
                )
            }.sheet(isPresented: $sheetState.isVisible) {
                switch sheetState.visibleScreen {
                case .albumPicker:
                    PhotoPicker(images: $images)
                case .cameraPicker:
                    CameraPicker(images: $images)
                }
            }
    }
}

struct ImagePickerButton_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerButton(images: .constant([]))
    }
}
