import SwiftUI

// A deliberately vibecoded home screen for a budget app. It carries the usual
// tells on purpose so you can try /unslop-swiftui on it. Do not copy from it.

struct HomeView: View {
    @State private var selectedTab = 0
    @State private var pulse = false
    @State private var appeared = false

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [Color(hex: "#5B34B8"), Color(hex: "#2E1872"), Color(hex: "#170D3D")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.purple.opacity(0.55))
                .frame(width: 300, height: 300)
                .blur(radius: 90)
                .offset(x: 140, y: -280)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    header
                    balanceCard
                        .padding(.top, 22)
                        .offset(x: appeared ? 0 : -400)
                    statsRow
                        .padding(.top, 13)
                        .offset(x: appeared ? 0 : 400)
                    insightCard
                        .padding(.top, 18)
                    chartCard
                        .padding(.top, 15)
                    transactions
                        .padding(.top, 21)
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 120)
            }

            tabBar
        }
        .preferredColorScheme(.dark)
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.5)) { appeared = true }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("Welcome back, Alex! 👋")
                    .font(.system(size: 28, weight: .black))
                    .foregroundStyle(
                        LinearGradient(colors: [Color(hex: "#F0ABFC"), Color(hex: "#818CF8")], startPoint: .leading, endPoint: .trailing)
                    )
                Text("Let's crush your money goals today!!")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.65))
            }
            Spacer()
            Text("PRO")
                .font(.system(size: 10, weight: .heavy))
                .tracking(1.5)
                .foregroundColor(.white)
                .padding(.horizontal, 9)
                .padding(.vertical, 5)
                .background(LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing))
                .clipShape(Capsule())
                .shadow(color: .purple.opacity(0.8), radius: 10)
            Text("🔔")
                .font(.system(size: 20))
                .padding(.leading, 7)
                .onTapGesture {}
        }
        .padding(.top, 11)
    }

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("TOTAL BALANCE")
                .font(.system(size: 11, weight: .bold))
                .tracking(2.5)
                .foregroundColor(Color(hex: "#C4B5FD"))
            Text("$12,480.5")
                .font(.system(size: 44, weight: .black, design: .rounded))
                .foregroundStyle(LinearGradient(colors: [.white, Color(hex: "#C4B5FD")], startPoint: .top, endPoint: .bottom))
            Text("+12%!! 🚀")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.green)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.green.opacity(0.2))
                .clipShape(Capsule())
        }
        .frame(width: 324, alignment: .leading)
        .padding(21)
        .glassEffect(.regular.tint(.purple.opacity(0.4)), in: .rect(cornerRadius: 28))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .circular)
                .stroke(LinearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.5)
        )
        .shadow(color: Color(hex: "#7C3AED").opacity(0.6), radius: 24, y: 12)
    }

    private var statsRow: some View {
        HStack(spacing: 11) {
            statCard(emoji: "💸", title: "SPENT", value: "$2,140", spark: [3, 5, 4, 7, 6, 9])
            statCard(emoji: "💰", title: "SAVED", value: "$860.00", spark: [2, 3, 5, 4, 6, 8])
            statCard(emoji: "🔥", title: "STREAK", value: "07", spark: [1, 2, 2, 3, 4, 5])
        }
    }

    private func statCard(emoji: String, title: String, value: String, spark: [CGFloat]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(emoji)
                .font(.system(size: 22))
                .shadow(color: .yellow, radius: 8)
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .tracking(1.8)
                .foregroundColor(.white.opacity(0.6))
            Text(value)
                .font(.system(size: 19, weight: .heavy))
                .foregroundColor(.white)
            HStack(alignment: .bottom, spacing: 3) {
                ForEach(spark.indices, id: \.self) { index in
                    Capsule()
                        .fill(LinearGradient(colors: [.pink, .purple], startPoint: .top, endPoint: .bottom))
                        .frame(width: 5, height: spark[index] * 3)
                }
            }
        }
        .padding(13)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: 22))
        .shadow(color: .purple.opacity(0.5), radius: 14)
    }

    private var insightCard: some View {
        HStack(spacing: 10) {
            Image(systemName: "sparkles")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(LinearGradient(colors: [.yellow, .pink], startPoint: .top, endPoint: .bottom))
                .scaleEffect(pulse ? 1.2 : 0.9)
            VStack(alignment: .leading, spacing: 2) {
                Text("AI Insight ✨")
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundColor(.white)
                Text("Supercharge your savings! Unlock $340 more this month by optimizing subscriptions.")
                    .font(.system(size: 12.5))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
            }
            Spacer()
            Text("New ✨")
                .font(.system(size: 10, weight: .heavy))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(LinearGradient(colors: [.pink, .purple], startPoint: .leading, endPoint: .trailing))
                .clipShape(Capsule())
                .shadow(color: .pink, radius: 8)
        }
        .padding(15)
        .background(
            LinearGradient(
                colors: [Color(hex: "#EC4899").opacity(0.35), Color(hex: "#8B5CF6").opacity(0.35)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.3)))
        .shadow(color: .pink.opacity(0.5), radius: 20)
        .opacity(pulse ? 1 : 0.85)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) { pulse = true }
        }
    }

    private let week: [(label: String, amount: CGFloat)] = [
        ("MON", 64), ("TUE", 112), ("WED", 48), ("THU", 96), ("FRI", 130), ("SAT", 82), ("SUN", 40),
    ]
    private let rainbow: [Color] = [.red, .orange, .yellow, .green, .cyan, .blue, .purple]

    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("WEEKLY SPENDING 📊")
                    .font(.system(size: 12, weight: .heavy))
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Text("This week ▾")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color.white.opacity(0.15)))
            }
            HStack(alignment: .bottom, spacing: 9) {
                ForEach(week.indices, id: \.self) { index in
                    VStack(spacing: 6) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(colors: [rainbow[index], rainbow[index].opacity(0.4)], startPoint: .top, endPoint: .bottom))
                            .frame(height: week[index].amount)
                            .shadow(color: rainbow[index].opacity(0.7), radius: 8)
                        Text(week[index].label)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
            }
            .frame(height: 156, alignment: .bottom)
        }
        .padding(17)
        .glassEffect(.regular, in: .rect(cornerRadius: 26))
    }

    private struct Item: Identifiable {
        let id: Int
        let emoji: String
        let name: String
        let date: String
        let amount: String
        let color: Color
        let padding: CGFloat
    }

    private let items: [Item] = [
        Item(id: 0, emoji: "☕️", name: "Starbucks", date: "Today, 8:14 AM", amount: "-$6.45", color: .orange, padding: 11),
        Item(id: 1, emoji: "💼", name: "Salary", date: "Yesterday", amount: "+$4,200", color: .green, padding: 8),
        Item(id: 2, emoji: "🍿", name: "Netflix", date: "Oct 28", amount: "-$15.99", color: .red, padding: 13),
        Item(id: 3, emoji: "🚗", name: "Uber", date: "10/27/2026", amount: "-$23.1", color: .blue, padding: 9),
        Item(id: 4, emoji: "🛒", name: "Whole Foods", date: "Oct 26", amount: "-$84.32", color: .mint, padding: 11),
    ]

    private var transactions: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("RECENT TRANSACTIONS 💳")
                .font(.system(size: 12, weight: .heavy))
                .tracking(2)
                .foregroundColor(.white.opacity(0.8))
            ForEach(items) { item in
                HStack {
                    Text(item.emoji)
                        .font(.system(size: 20))
                        .frame(width: 42, height: 42)
                        .background(Circle().fill(item.color.opacity(0.25)))
                        .shadow(color: item.color, radius: 6)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(item.name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                        Text(item.date)
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    Spacer()
                    Text(item.amount)
                        .font(.system(size: 15, weight: .heavy))
                        .foregroundColor(item.amount.hasPrefix("+") ? .green : .white)
                }
                .padding(.vertical, item.padding)
                .padding(.horizontal, 14)
                .glassEffect(.regular, in: .rect(cornerRadius: 18))
                .onTapGesture {}
            }
        }
    }

    private let tabs: [(icon: String, title: String)] = [("🏠", "HOME"), ("📊", "STATS"), ("💳", "CARDS"), ("⚙️", "SETTINGS")]

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { index in
                VStack(spacing: 3) {
                    Text(tabs[index].icon)
                        .font(.system(size: 20))
                    Text(tabs[index].title)
                        .font(.system(size: 9, weight: .bold))
                }
                .foregroundColor(selectedTab == index ? .white : .white.opacity(0.5))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing))
                        .shadow(color: .purple, radius: 12)
                        .opacity(selectedTab == index ? 1 : 0)
                )
                .scaleEffect(selectedTab == index ? 1.08 : 1)
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) { selectedTab = index }
                }
            }
        }
        .padding(7)
        .glassEffect(.regular.tint(.purple.opacity(0.3)), in: .capsule)
        .shadow(color: .purple.opacity(0.6), radius: 20, y: 10)
        .padding(.horizontal, 22)
        .padding(.bottom, 6)
    }
}

extension Color {
    init(hex: String) {
        let value = UInt64(hex.trimmingCharacters(in: CharacterSet(charactersIn: "#")), radix: 16) ?? 0
        self.init(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }
}

#Preview {
    HomeView()
}
