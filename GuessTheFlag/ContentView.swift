//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Palino on 24/11/2021.
//

import SwiftUI
import AVFoundation

struct FlagView: View {
    var image: String
    
    // Flag view
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 1))
            .shadow(color: Color.white.opacity(0.7), radius: 6, x: 2, y: 3)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var scoreTitle = ""
    @State private var smallMessage = ""
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var soundID: SystemSoundID = 0
    @State private var playerScore = 0
    @State private var playerLives = 0
    
    @State private var countries = ["Afghanistan", "Åland Islands", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Caribbean Netherlands", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Cocos Islands", "Colombia", "Comoros", "Republic of the Congo", "DR Congo", "Cook Islands", "Costa Rica", "Ivory Coast", "Croatia", "Cuba", "Curaçao", "Cyprus", "Czechia", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "England", "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini", "Ethiopia", "Falkland Islands", "Faroe Islands", "Fiji", "Finland", "France", "French Guiana", "French Polynesia", "French Southern and Antarctic Lands", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guernsey", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard Island and McDonald Islands", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Isle of Man", "Israel", "Italy", "Jamaica", "Japan", "Jersey", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "North Korea", "South Korea", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "North Macedonia", "Northern Ireland", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn Islands", "Poland", "Portugal", "Puerto Rico", "Qatar", "Réunion", "Romania", "Russia", "Rwanda", "Saint Barthélemy", "Saint Helena, Ascension and Tristan da Cunha", "Saint Kitts and Nevis", "Saint Lucia", "Saint Martin", "Saint Pierre and Miquelon", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "São Tomé and Príncipe", "Saudi Arabia", "Scotland", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Sint Maarten", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Svalbard and Jan Mayen", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States of America", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "British Virgin Islands", "United States Virgin Islands", "Wales", "Wallis and Futuna", "Western Sahara", "Yemen", "Zambia", "Zimbabwe"].shuffled()

    var player: AVAudioPlayer?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.6, blue: 0.8), Color(red: 0.4, green: 0.7, blue: 0.4)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 30) {

                Spacer()
                
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.title2)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button {
                        flagTapped(number)
                    } label: {
                        FlagView(image: countries[number])
                    }
                }
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("\(playerScore)")
                        .foregroundColor(.white)
                        .fontWeight(.black)
                        .font(.largeTitle)
                        .padding()

                    Spacer()
                    
                    ForEach(1 ..< 6) { lives in
                        if lives <= playerLives {
                            Image(systemName: "flag")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding(1)
                        } else {
                            Image(systemName: "flag.fill")
                                .foregroundColor(.white)
                                .font(.title)
                                .padding(1)
                        }
                    }
                }
                
            }
        }
        .alert(isPresented: $gameOver) {
            Alert(title: Text("Game Over"),
                  message: Text("You achived \(playerScore) points"),
                  dismissButton: .default(Text("New Game")) {
                    gameOver = false
                    playerScore = 0
                    playerLives = 0
                    askQuestion()
                  })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            playerScore += 1
            askQuestion()
            soundID = 1057
        } else {
            playerLives += 1
            soundID = 1053
            if (playerLives >= 5) {
                gameOver = true
                soundID = 1027
            } else {
                askQuestion()
            }
        }
        AudioServicesPlaySystemSound(soundID)
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
