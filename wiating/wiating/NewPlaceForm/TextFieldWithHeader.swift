//
//  TextFieldWithHeader.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 10/12/2021.
//

import SwiftUI

struct TextFieldWithHeader: View {
    @Binding var input: String
    
    enum ValidationState {
        case initial
        case commited
    }
    
    @State private var validationState: ValidationState = .initial

    
    var newInput: Binding<String> {
        if input.isEmpty, !textFocused {
            return $label
        } else {
            return $input
        }
    }
    
    var foregroundColor: Color {
        textFocused ? .primary : .secondary
    }
    
    @State var label: String
    
    var editingDidEnd: () -> Void = {}
    
    var isMultiline: Bool = false
    
    @FocusState private var textFocused: Bool
    
    @Binding var focusModel: FocusedScrollViewReaderModel
    
    var id: Int?
    
    var required: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if input.count > 0 {
                Text(label).font(.system(size: 12)).foregroundColor(.secondary)
            }

            if !isMultiline {
                TextField(label, text: $input)
                    .onSubmit {
                        editingDidEnd()
                    }
                    .foregroundColor(foregroundColor).focused($textFocused)
            } else {
                TextEditor(text: newInput)
                    .foregroundColor(foregroundColor)
                    .onSubmit {
                        editingDidEnd()
                    }
                    .focused($textFocused)
            }
            
            if validationState == .commited, input.isEmpty {
                Text("To pole jest obowiązkowe.").font(.system(size: 10.0)).foregroundColor(Color.red)
            }
        }.onChange(of: textFocused) { _ in
            focusModel.focusedId = id
        }.onChange(of: input) { _ in
            if !input.isEmpty { validationState = .commited }
        }
        .id(id)
    }
}

struct TextFieldWithHeader_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithHeader(input: .constant(""), label: "", focusModel: .constant(FocusedScrollViewReaderModel()))
    }
}
