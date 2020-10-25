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
    @State var wordBank = vocab
    @State var shownWord : String = getRandomWord(wordBank: vocab)
    @State var showPronunciation : Bool = false
    @State var toRetryWords = {}
    @State var correctCount = 0
    @State var finished: Bool = false
    @State var prevShownWord: String?
    var body: some View {
        HStack(alignment:VerticalAlignment.top, spacing: 20, content: {
            Text("\(self.correctCount) / \(vocabDict.count)")
                .foregroundColor(Color.white)
                .background(Color.black)
                .font(.title)
        })
        .foregroundColor(Color.white)
        .background(Color.black)
        if !self.finished {
            VStack(alignment: HorizontalAlignment.center, spacing: 20, content: {
                // on tapping text, show value of key lulz.
                Text("\(self.shownWord)").onTapGesture(perform: {
                    self.finished = getNextFlashcardAndContinue(view: self)
                })
                HStack(alignment: VerticalAlignment.center, spacing: 20, content: {
                    // Mark correct
                    Button(action:{
                        self.correctCount += 1
                        if self.prevShownWord != nil {
                            self.wordBank.removeAll(where: {$0 == self.prevShownWord})
                        }
                        self.finished = getNextFlashcardAndContinue(view: self)
                    }) {
                        Image(systemName: "checkmark").resizable()
                            .frame(width:24.0, height: 24.0)
                    }
                    .padding()
                    .background(self.showPronunciation ? Color.green : Color.green.opacity(0.4))
                    .cornerRadius(10, antialiased:true)
                    .disabled(!self.showPronunciation)
                    // Mark to retry word
                    Button(action:{
                        self.finished = getNextFlashcardAndContinue(view: self)
                    }) {
                        Image(systemName: "arrow.clockwise").resizable()
                            .frame(width:24.0, height: 24.0)
                    }
                    .padding()
                    .background(self.showPronunciation ? Color.orange : Color.orange.opacity(0.4))
                    .cornerRadius(10, antialiased: true)
                    .disabled(!self.showPronunciation)
                })
            })
            .foregroundColor(Color.white)
            .font(.system(size: 80, weight: .heavy, design: .default))
            .frame(minWidth: 0,
                   maxWidth: UIScreen.main.bounds.width,
                   minHeight: 0,
                   maxHeight: UIScreen.main.bounds.height,
                   alignment: .center)
            .background(Color.black)
        } else {
            VStack(alignment:HorizontalAlignment.center, spacing: 20, content:{
                Text("Congratulations! You finished 🎊 🥳 ")
                    .padding()
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                Button(action:{
                    self.wordBank = vocab
                    self.correctCount = 0
                    self.shownWord = getRandomWord(wordBank: self.wordBank)
                    self.showPronunciation = false
                    self.toRetryWords = {}
                    self.prevShownWord = nil
                    self.finished = false
                }) {
                    Text("Try again?")
                        .font(.subheadline)
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10, antialiased: true)
            })
            .foregroundColor(Color.white)
            .font(.system(size: 80, weight: .heavy, design: .default))
            .frame(minWidth: 0,
                   maxWidth: UIScreen.main.bounds.width,
                   minHeight: 0,
                   maxHeight: UIScreen.main.bounds.height,
                   alignment: .center)
            .background(Color.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func getNextFlashcardAndContinue(view: ContentView) -> Bool {
    if view.wordBank.count > 0 {
        view.showPronunciation = !view.showPronunciation
        view.prevShownWord = view.shownWord
        view.shownWord = view.showPronunciation
            ? (vocabDict[view.shownWord] ?? "")
            : getRandomWord(wordBank: view.wordBank)
        return false
    }
    guard view.correctCount == vocabDict.count else {
        print("something went wrong and I dont't want to handle error")
        print("resetting'ish")
        view.wordBank = vocab
        view.correctCount = 0
        view.showPronunciation = !view.showPronunciation
        view.prevShownWord = view.shownWord
        view.shownWord = view.showPronunciation
            ? (vocabDict[view.shownWord] ?? "")
            : getRandomWord(wordBank: view.wordBank)
        return false
    }
    return true
}

func getRandomWord(wordBank: [String]) -> String {
    return wordBank[wordBank
                        .index(wordBank.startIndex,
                               offsetBy: Int.random(in:0..<wordBank.count)
                        )
    ]
}

enum VocabError: Error {
    case UnequalCountBetweenWordbankAndCorrectCount
    case General
}
