import SwiftUI

struct ContentView: View {
    @State var place: Place?

    let places: [Place] = [
        Place(name: "Barcelona", image: "barcelona"),
        Place(name: "Paris", image: "paris"),
        Place(name: "New York", image: "nyc"),
        Place(name: "Rome", image: "rome"),
        Place(name: "London", image: "london"),
        Place(name: "Dubai", image: "dubai"),
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text(place?.name ?? "")
                .font(.headline)
                .padding(.horizontal, 32)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(places) { place in
                        Image(place.image)
                            .resizable()
                            .cornerRadius(15)
                            .frame(width: 200, height: 200)
                            .shadow(radius: 10, y: 10)
                            .scrollTransition(topLeading: .interactive,
                                              bottomTrailing: .interactive,
                                              axis: .horizontal) { effect, phase in
                                effect
                                    .scaleEffect(1 - abs(phase.value))
                                    .opacity(1 - abs(phase.value))
                                    .rotation3D(.degrees(phase.value * 90),
                                                axis: (x: 0, y: 1, z: 0))
                            }
                            .onTapGesture {
                                withAnimation {
                                    self.place = place
                                }
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .frame(height: 200)
            .safeAreaPadding(.horizontal, 32)
            .scrollClipDisabled()
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $place)
            .onAppear {
                place = places[2]
            }

            HStack {
                Button {
                    withAnimation {
                        guard let place, let index = places.firstIndex(of: place),
                              index > 0 else { return }
                        self.place = places[index - 1]
                    }
                } label: {
                    Image(systemName: "arrow.left.square.fill")
                        .font(.system(size: 32))
                }
                .disabled(place == places.first)

                Button {
                    withAnimation {
                        guard let place, let index = places.firstIndex(of: place),
                              index < places.count - 1 else { return }
                        self.place = places[index + 1]
                    }
                } label: {
                    Image(systemName: "arrow.right.square.fill")
                        .font(.system(size: 32))
                }
                .disabled(place == places.last)
            }
            .padding(32)

            Spacer()
        }
    }
}

#Preview {
    ContentView()
}

struct Place: Hashable, Identifiable {
    var id: Self { self }

    let name: String
    let image: String
}
