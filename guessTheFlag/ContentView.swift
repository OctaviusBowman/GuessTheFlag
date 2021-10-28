//
//  ContentView.swift
//  guessTheFlag
//
//  Created by Octavius Bowman on 9/25/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var animationAmount = 0.0
    @State private var isClickedFlagCorrect = false
    
    var body: some View {
        ZStack() {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                VStack() {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action:{
                        withAnimation(.default) {
                            self.flagTapped(number)
                            self.animationAmount += 360
                            if (scoreTitle == "Correct") {
                                 isClickedFlagCorrect = true
                            }
                        }
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    }.rotation3DEffect(.degrees(animationAmount), axis:(x: 0, y: self.isClickedFlagCorrect ? ((number == self.correctAnswer) ? 1 : 0) : 0 , z: 0))
                        .opacity(!(number == self.correctAnswer) && self.showingScore ? 0.25 : 1)
                    
                }
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: scoreTitle == "Correct" ? Text("Your score is \(userScore)") :
                    Text("The correct answer is flag # \(correctAnswer + 1) \n Your score is now \(userScore)"),
                  dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
        } else {
            scoreTitle = "Wrong!"
            /* Alternalive wrong answer message */
            // scoreTitle = "Wrong! That the flag for the country of \(countries[number])"
            if(userScore == 0) {
                userScore = 0
            } else {
                userScore -= 1
            }
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        isClickedFlagCorrect = false
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
