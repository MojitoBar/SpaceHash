import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var scene: GameScene = {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.speed = 1
        return scene
    }()
    
    @Binding var start: Bool
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            if scene.gameOver {
                VStack {
                    VStack {
                        Spacer()
                        Text("SCORE")
                            .font(Font.system(size: 18, weight: .bold, design: .default))
                        Text("\(scene.score)")
                            .font(Font.system(size: 20, weight: .bold, design: .default))
                        
                        Spacer()
                        Text("BEST")
                            .font(Font.system(size: 18, weight: .bold, design: .default))
                        Text("\(userDefaults.integer(forKey: "maxValue"))")
                            .font(Font.system(size: 20, weight: .bold, design: .default))
                        
                        Spacer()
                        Button {
                            start = false
                        } label: {
                            Text("RETRY")
                                .font(Font.system(size: 25, weight: .bold, design: .default))
                        }
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .frame(width: 200, height: 350, alignment: .center)
                    .background(Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.7))
                    .cornerRadius(8)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                .background(Color.init(red: 1, green: 1, blue: 1, opacity: 0.1))
            }
        }
    }
}

struct RootView: View {
    @State var start: Bool = false
    var body: some View {
        if !start {
            IntroView(start: $start)
        }
        else {
            ContentView(start: $start)
        }
    }
}

struct IntroView: View {
    @Binding var start: Bool
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("SPACE DODGE")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .font(.system(.headline, design: .monospaced))
                    .fontWeight(.bold)
                
                Spacer()
                
                Button {
                    start = true
                } label: {
                    Text("GAME START")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .font(.system(.headline, design: .monospaced))
                        .fontWeight(.bold)
                }
            }
            .frame(width: 300, height: 500, alignment: .center)
        }
    }
}
