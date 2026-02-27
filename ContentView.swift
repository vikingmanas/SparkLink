import SwiftUI
import Combine

// MARK: - 1. DATA MODELS (Anonymous & Safe)
struct PeerProfile: Identifiable {
    let id = UUID()
    let pseudonym: String     // e.g., "NeonWalker"
    let year: String          // e.g., "Junior"
    let major: String         // e.g., "Computer Science"
    let avatarIcon: String    // System icon (No real photos for safety)
    let helpTags: [String]    // "How can I help?"
    let bio: String
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isMe: Bool
    let time: Date
}

// MARK: - 2. MAIN DASHBOARD VIEW
struct ContentView: View {
    @StateObject private var radar = RadarManager()
    @StateObject private var mentor = CommunityMentor()
    
    // UI Animation State
    @State private var isSparkActive = false
    @State private var pulseSize: CGFloat = 1.0
    @State private var detectedPeer: PeerProfile? = nil

    var body: some View {
        ZStack {
            // LAYER 1: "PRIDE RADIANCE" THEME (Stable Version)
            // This replicates your reference image using high-performance gradients
            ZStack {
                Color.black.ignoresSafeArea()
                
                // The woven light effect
                AngularGradient(
                    gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red]),
                    center: .center
                )
                .blur(radius: 60) // Softens it into "light"
                .opacity(0.6)
                .ignoresSafeArea()
                .rotationEffect(.degrees(isSparkActive ? 360 : 0)) // Slow spin when active
                .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: isSparkActive)
            }
            
            VStack(spacing: 30) {
                // Header
                Text("SparkLink")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .purple.opacity(0.5), radius: 10)
                
                // LAYER 2: THE LIQUID GLASS RADAR
                ZStack {
                    // Glass Container
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .foregroundStyle(.clear) // Transparent base
                        .background(.ultraThinMaterial) // The Blur Effect
                        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 40, style: .continuous)
                                .stroke(LinearGradient(colors: [.white.opacity(0.5), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                        )
                    
                    VStack {
                        // The Interactive Spark Button
                        Button(action: {
                            if radar.nearbySparks > 0 {
                                // SIMULATION: Open the Found Profile
                                self.detectedPeer = PeerProfile(
                                    pseudonym: "NeonWalker",
                                    year: "Junior",
                                    major: "Digital Arts",
                                    avatarIcon: "person.crop.circle.badge.moon",
                                    helpTags: ["Safe Walk", "SwiftUI Help", "Coffee Chat"],
                                    bio: "Designing for the future. Love sci-fi and chai."
                                )
                            }
                        }) {
                            ZStack {
                                // Pulse Animation
                                if isSparkActive {
                                    Circle()
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                        .frame(width: 200, height: 200)
                                        .scaleEffect(pulseSize)
                                        .opacity(2 - pulseSize)
                                        .onAppear {
                                            withAnimation(.easeOut(duration: 2).repeatForever(autoreverses: false)) {
                                                pulseSize = 2.0
                                            }
                                        }
                                }
                                
                                // Core Button
                                Circle()
                                    .fill(
                                        RadialGradient(colors: [.white, .white.opacity(0.2)], center: .center, startRadius: 5, endRadius: 80)
                                    )
                                    .frame(width: 120, height: 120)
                                    .opacity(isSparkActive ? 0.9 : 0.2)
                                    .blur(radius: isSparkActive ? 0 : 15) // Fog vs Clarity
                                    .overlay(
                                        Image(systemName: "hand.tap.fill")
                                            .font(.largeTitle)
                                            .foregroundStyle(.black)
                                            .opacity(radar.nearbySparks > 0 ? 1 : 0)
                                            .scaleEffect(radar.nearbySparks > 0 ? 1.2 : 0.8)
                                            .animation(.bouncy, value: radar.nearbySparks)
                                    )
                            }
                        }
                        .disabled(radar.nearbySparks == 0) // Only clickable if spark found
                        
                        // Dynamic Status Text
                        Group {
                            if isSparkActive {
                                if radar.nearbySparks > 0 {
                                    Text("Spark Found! Tap to Connect")
                                        .foregroundStyle(Color.green.gradient)
                                        .fontWeight(.bold)
                                } else {
                                    Text("Scanning Safe Zone...")
                                        .foregroundStyle(.white.opacity(0.8))
                                }
                            } else {
                                Text("Spark Dormant")
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                        .font(.headline)
                        .padding(.top, 15)
                    }
                }
                .frame(height: 320)
                .padding(.horizontal, 20)
                
                // LAYER 3: AI MENTOR (Privacy & Safety)
                if isSparkActive {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "brain.head.profile")
                            Text("Community Mentor")
                                .font(.caption.bold())
                                .textCase(.uppercase)
                        }
                        .foregroundStyle(.white.opacity(0.7))
                        
                        Text(mentor.currentPrompt)
                            .font(.subheadline.italic())
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                Spacer()
                
                // MAIN ACTION BUTTON
                Button(action: toggleSpark) {
                    HStack {
                        Image(systemName: isSparkActive ? "eye.slash.fill" : "antenna.radiowaves.left.and.right")
                        Text(isSparkActive ? "Go Stealth" : "Illuminate Spark")
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(isSparkActive ? .white : .black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isSparkActive ? Color.red.opacity(0.8) : Color.white)
                    .clipShape(Capsule())
                    .shadow(radius: 10)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        // ANONYMOUS PROFILE SHEET
        .sheet(item: $detectedPeer) { peer in
            AnonymousProfileView(peer: peer)
                .presentationDetents([.fraction(0.75), .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    // Logic: Toggle State
    func toggleSpark() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isSparkActive.toggle()
            if isSparkActive {
                mentor.generateSafePrompt()
                radar.startScanning()
            } else {
                radar.stopScanning()
                pulseSize = 1.0
            }
        }
    }
}

// MARK: - 3. ANONYMOUS PROFILE & CHAT
struct AnonymousProfileView: View {
    let peer: PeerProfile
    @State private var messageText = ""
    @State private var messages: [ChatMessage] = []
    @State private var isChatting = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                if !isChatting {
                    // --- PROFILE MODE ---
                    ScrollView {
                        VStack(spacing: 20) {
                            // Avatar with Pride Ring
                            Image(systemName: peer.avatarIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 90, height: 90)
                                .foregroundStyle(.white)
                                .padding(25)
                                .background(
                                    Circle()
                                        .strokeBorder(
                                            AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .red], center: .center),
                                            lineWidth: 5
                                        )
                                )
                                .padding(.top, 40)
                            
                            // Pseudonym Info
                            VStack(spacing: 5) {
                                Text(peer.pseudonym)
                                    .font(.title.bold())
                                    .foregroundStyle(.white)
                                Text("\(peer.year) • \(peer.major)")
                                    .font(.headline)
                                    .foregroundStyle(.gray)
                            }
                            
                            // Bio
                            Text(peer.bio)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white.opacity(0.8))
                                .padding(.horizontal)
                            
                            Divider().background(.gray).padding()
                            
                            // Help Tags
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Looking for support in:")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                    .textCase(.uppercase)
                                    .padding(.horizontal)
                                
                                // Tag Flow Layout
                                HStack {
                                    ForEach(peer.helpTags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption.bold())
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Capsule().fill(Color.indigo.opacity(0.5)))
                                            .foregroundStyle(.white)
                                            .overlay(Capsule().stroke(.white.opacity(0.3), lineWidth: 1))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Chat Button
                    Button(action: { withAnimation { isChatting = true } }) {
                        Label("Message Anonymously", systemImage: "bubble.left.and.bubble.right.fill")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    .padding(20)
                    
                } else {
                    // --- CHAT MODE ---
                    VStack {
                        // Chat Header
                        HStack {
                            Button(action: { withAnimation { isChatting = false } }) {
                                Image(systemName: "chevron.left").foregroundStyle(.white)
                            }
                            Spacer()
                            Text(peer.pseudonym).font(.headline).foregroundStyle(.white)
                            Spacer()
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        
                        // Messages List
                        ScrollViewReader { proxy in
                            ScrollView {
                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(messages) { msg in
                                        HStack {
                                            if msg.isMe { Spacer() }
                                            Text(msg.text)
                                                .padding(12)
                                                .background(msg.isMe ? Color.blue : Color(UIColor.systemGray6))
                                                .foregroundStyle(.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                            if !msg.isMe { Spacer() }
                                        }
                                        .id(msg.id)
                                    }
                                }
                                .padding()
                            }
                            .onChange(of: messages.count) { _ in
                                if let last = messages.last {
                                    withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                                }
                            }
                        }
                        
                        // Input Field
                        HStack {
                            TextField("Type a message...", text: $messageText)
                                .padding(12)
                                .background(Color(UIColor.systemGray6))
                                .clipShape(Capsule())
                                .focused($isFocused)
                                .foregroundStyle(.white)
                            
                            Button(action: sendMessage) {
                                Image(systemName: "paperplane.fill")
                                    .font(.title3)
                                    .foregroundStyle(.blue)
                            }
                            .disabled(messageText.isEmpty)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                    }
                }
            }
        }
    }
    
    // Chat Logic
    func sendMessage() {
        guard !messageText.isEmpty else { return }
        let newMsg = ChatMessage(text: messageText, isMe: true, time: Date())
        withAnimation { messages.append(newMsg) }
        messageText = ""
        isFocused = false
        
        // Simulating Reply
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let reply = ChatMessage(text: "Hey! I'm nearby. I'd love to chat!", isMe: false, time: Date())
            withAnimation { messages.append(reply) }
        }
    }
}

// MARK: - 4. LOGIC MANAGERS (Thread Safe)

@MainActor
class CommunityMentor: ObservableObject {
    @Published var currentPrompt: String = ""
    
    func generateSafePrompt() {
        let safeTopics = [
            "Ask about their favorite queer-friendly art class!",
            "See if they want to study at the 'Rainbow Cafe'.",
            "Ask: 'What is your favorite safe space on campus?'"
        ]
        // Artificial Delay for realism
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentPrompt = safeTopics.randomElement() ?? "Say Hello!"
        }
    }
}

@MainActor
class RadarManager: ObservableObject {
    @Published var nearbySparks: Int = 0
    
    func startScanning() {
        // SIMULATION MODE:
        // We simulate finding a peer after 2 seconds because
        // UWB hardware does not exist in the Playground Simulator.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                self.nearbySparks = 1
            }
        }
    }
    
    func stopScanning() {
        nearbySparks = 0
    }
}
