//
//  ContentView.swift
//  testing
//
//  Created by Sarah Chen on 10/23/20.
//  Copyright © 2020 Sarah Chen. All rights reserved.
//

import SwiftUI

var vocab = ["あ","ア" ,"ザ" ,"ざ","エ","え","ビ","び"]
var pronunications = ["a", "a", "za", "za", "e", "e", "bi", "bi"]
let vocabDict = Dictionary(uniqueKeysWithValues: zip(vocab,pronunications))

struct ContentView: View {
    @State var shownWord : String = getRandomWord()
    @State var showPronunciation : Bool = false
    var body: some View {
        // on tapping text, show value of key lulz.
        Text("\(self.shownWord)").onTapGesture(perform: {
            self.showPronunciation = !self.showPronunciation
            if (self.showPronunciation) {
                self.shownWord = vocabDict[self.shownWord] ?? ""
            } else {
                self.shownWord = getRandomWord()
            }
        })
            .foregroundColor(Color.white)
            .font(.system(size: 80, weight: .heavy, design: .default))
            .frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width, minHeight: 0, maxHeight: UIScreen.main.bounds.height, alignment: .center)
            .background(Color.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func getRandomWord() -> String {
    return vocab[vocab.index(vocab.startIndex, offsetBy: Int.random(in:0..<vocab.count))]
}
