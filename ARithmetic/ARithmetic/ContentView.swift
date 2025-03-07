//
//  ContentView.swift
//  ARithmetic
//
//  Created by Elana Chen-Jones on 12/24/22.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    var body: some View {
        StartView()
    }
}

struct ARViewContainer: UIViewRepresentable {
    var arView: CustomARView
    
    func makeUIView(context: Context) -> ARView {
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) { }
}

struct StartView: View {
    //@State var navTarget: String? = nil
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 100) {
                Text("ARithmetic")
                    .font(.largeTitle.bold())
                    .foregroundColor(.accentColor)
                    .padding()
                NavigationLink(destination: LevelsView()) {
                    Image(systemName: "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100, alignment: .center)
                }
                .padding()
                Spacer()
            }
        }
    }
}

struct LevelsView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 80) {
            NavigationLink(destination: AdditionView(questionNum: 1)) {
                Image(systemName: "plus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80, alignment: .center)
            }
            NavigationLink(destination: SubtractionView(questionNum: 1)) {
                Image(systemName: "minus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80, alignment: .center)
            }
        }
        .padding()
        HStack(alignment: .center, spacing: 80) {
            NavigationLink(destination: MultiplicationView(questionNum: 1)) {
                Image(systemName: "multiply")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80, alignment: .center)
            }
            NavigationLink(destination: DivisionView(questionNum: 1)) {
                Image(systemName: "divide")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80, alignment: .center)
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Let's Practice!")
                    .font(.title)
                    .foregroundColor(.accentColor)
                    .accessibilityAddTraits(.isHeader)
            }
        }
        .padding()
    }
}

struct AdditionView: View {
    @StateObject var arView = CustomARView(addition: true, subtraction: false)
    var questionNum: Int
    
    var body: some View {
        VStack {
            Text("\(arView.count)")
                .font(.system(size: 50))
                .foregroundColor(.accentColor)
            ARViewContainer(arView: arView).ignoresSafeArea(.all)
            HStack {
                ZStack {
                    Text("\(arView.num1) + \(arView.num2) = ?")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accentColor)
                        .padding()
                    HStack {
                        Spacer()
                        NavigationLink(destination: EquationView(num1: arView.num1, num2: arView.num2, type: "+", questionNum: questionNum, arView: arView)) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30, alignment: .center)
                                .padding()
                        }
                        .disabled(arView.num1 + arView.num2 != arView.count)
                        .navigationBarHidden(true)
                    }
                }
            }
        }
    }
}

struct SubtractionView: View {
    @StateObject var arView = CustomARView(addition: false, subtraction: true)
    var questionNum: Int
    
    var body: some View {
        VStack {
            Text("\(arView.count)")
                .font(.system(size: 50))
                .foregroundColor(.accentColor)
            ARViewContainer(arView: arView).ignoresSafeArea(.all)
            HStack {
                ZStack {
                    Text("\(arView.num1) - \(arView.num2) = ?")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.accentColor)
                        .padding()
                    HStack {
                        Spacer()
                        NavigationLink(destination: EquationView(num1: arView.num1, num2: arView.num2, type: "-", questionNum: questionNum, arView: arView)) {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30, alignment: .center)
                                .padding()
                        }
                        .disabled(arView.num1 - arView.num2 != arView.count)
                        .navigationBarHidden(true)
                    }
                }
            }
        }
    }
}

struct MultiplicationView: View {
    var questionNum: Int
    
    var body: some View {
        Text("Coming Soon!")
            .font(.largeTitle)
    }
}

struct DivisionView: View {
    var questionNum: Int
    
    var body: some View {
        Text("Coming Soon!")
            .font(.largeTitle)
    }
}

struct EquationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var num1: Int
    var num2: Int
    var type: Character
    var questionNum: Int
    var arView: CustomARView
    
    var body: some View {
        if (type == "+") {
            VStack(alignment: .center, spacing: 40) {
                Text("\(num1) + \(num2) = \(num1 + num2)")
                    .font(.system(size: 80))
                Button(action: {
                    if (questionNum == 10) {
                        print("FINISHED!")
                        //NavigationLink(destination: LevelsView())
                    }
                    else {
                        arView.reset(addition: true, subtraction: false) // addition vs subtraction
                        dismiss()
                    }
                }, label: {
                    Image(systemName: "arrow.forward.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding()
                })
                .navigationBarHidden(true)
                /*if (questionNum == 10) { // finishes after 10 questions
                    NavigationLink(destination: LevelsView()) {
                        Image(systemName: "arrow.forward.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50, alignment: .center)
                            .padding()
                    }
                    .navigationBarHidden(true)
                }
                else {
                    NavigationLink(destination: AdditionView(questionNum: questionNum + 1)) {
                        Image(systemName: "arrow.forward.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50, alignment: .center)
                            .padding()
                    }
                    .navigationBarHidden(true)
                }*/
            } // hide navigation bar
        }
        else if (type == "-") {
            VStack(alignment: .center, spacing: 40) {
                Text("\(num1) - \(num2) = \(num1 - num2)")
                    .font(.system(size: 80))
                Button(action: {
                    if (questionNum == 10) {
                        print("FINISHED!")
                        //NavigationLink(destination: LevelsView())
                    }
                    else {
                        arView.reset(addition: false, subtraction: true) //addition vs subtraction
                        dismiss()
                    }
                }, label: {
                    Image(systemName: "arrow.forward.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50, alignment: .center)
                        .padding()
                })
                .navigationBarHidden(true)
                /*if (questionNum == 10) { // finishes after 10 questions
                    NavigationLink(destination: LevelsView()) {
                        Image(systemName: "arrow.forward.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50, alignment: .center)
                            .padding()
                    }
                    .navigationBarHidden(true)
                }
                else {
                    NavigationLink(destination: SubtractionView(questionNum: questionNum + 1)) {
                        Image(systemName: "arrow.forward.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50, alignment: .center)
                            .padding()
                    }
                    .navigationBarHidden(true)
                }*/
            }
        }
    }
}

// second, third, etc. ARViews increasingly glitchy and eventually crashes, possibly fixed?

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
