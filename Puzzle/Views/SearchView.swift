//
//  SearchView.swift
//  Subak
//
//  Created by Agus Hery on 23/04/22.
//
import SwiftUI

struct SearchView: View {
    var winAction: (() -> Void)?
    private var rowsNum: Int = 14
    private var columnsNum: Int = 14

    private var chars: [[Character]]
    @Binding var words: [String]
    @Binding var foundWords: [String]

    @State private var clicked: [Bool] = Array.init(repeating: false, count: 100)

    @State private var gridColumns: [GridItem] = Array.init(repeating: GridItem(.flexible(minimum: 25, maximum: 25), spacing: 0), count: 14)

    @GestureState private var location: CGPoint = .zero

    @Binding var selected: [(Int, Int)]
    @Binding var correctSelections: [[(Int, Int)]]
    @State private var highlighted: (Int, Int)? = nil
    @State private var curWord: String = ""
    @State var showModal: Bool = false

    init(grid:[[Character]], words: Binding<[String]>, foundWords: Binding<[String]>, selected: Binding<[(Int, Int)]>, correctSelections: Binding<[[(Int, Int)]]>) {
        self.rowsNum = grid.count
        self.columnsNum = grid[0].count

        self.chars = grid

        self._words = words
        self._foundWords = foundWords
        self._selected = selected
        self._correctSelections = correctSelections

        self.gridColumns = Array.init(repeating: GridItem(.flexible(minimum: 25, maximum: 25), spacing: 0), count: columnsNum)
    }

    func reset() {
        self.selected = []
        self.correctSelections = []
        self.highlighted = nil
    }

    func rectReader(row: Int, column: Int) -> some View {
        return GeometryReader { (geometry) -> AnyView in
            if geometry.frame(in: .global).contains(self.location) {
                DispatchQueue.main.async {
                    selected.removeAll(where: { $0 == (row, column) })
                    self.selected.append((row, column))
                    straightenLine()
                }
            }

            let fillColor = Color.pink.opacity(0.5 * Double(self.correctSelections.flatMap { $0 }.filter{ $0 == (row, column) }.count))
            return AnyView(Rectangle().fill(fillColor))
        }
    }

    func straightenLine() -> Void {
        if selected.count < 1 { return }
        var newSelected: [(Int, Int)] = [selected.first!]
        var closestDistance: Double = 10000.0

        var dirX: Int = selected.last!.0 - selected.first!.0
        if dirX != 0 {
            dirX = dirX < 0 ? -1 : 1
        }

        var dirY = abs(selected.last!.1) - selected.first!.1
        if dirY != 0 {
            dirY = dirY < 0 ? -1 : 1
        }

        let possibleDirs = Direction.allCases.filter {
            [0, dirX].contains($0.vecDir.0) && [0, dirY].contains($0.vecDir.1)
        }

        let xRange = min(selected.first!.0, selected.last!.0)...max(selected.first!.0, selected.last!.0)

        let yRange = min(selected.first!.1, selected.last!.1)...max(selected.first!.1, selected.last!.1)

        for d in possibleDirs {
            var lastComp = 1000.0, x = selected.first!.0, y = selected.first!.1
            var tmpLine: [(Int, Int)] = []

            while xRange ~= x && yRange ~= y {
                tmpLine.append((x, y))

                let dist = distanceBetween(a: (x, y), b: selected.last!)

                if dist > lastComp {
                    break
                }

                if dist < closestDistance {
                    newSelected = tmpLine
                    closestDistance = dist
                }

                lastComp = dist
                x += d.vecDir.0
                y += d.vecDir.1
            }
        }

        self.selected = newSelected
    }

    func distanceBetween(a: (Int, Int), b: (Int, Int)) -> Double {
        return sqrt(pow(Double(a.0 - b.0), 2) + pow(Double(a.1 - b.1), 2))
    }

    func validateSelection() -> Void {
        let word = selected.map({
            String(chars[$0.0][$0.1])
        }).joined()

        let reversed = selected.reversed().map({
            String(chars[$0.0][$0.1])
        }).joined()

        var valid: String? = nil

        if words.contains(word) {
            showModal = true
            valid = word
        } else if words.contains(reversed) {
            valid = reversed
        } else {
            return
        }

        self.correctSelections.append(self.selected)
        self.foundWords.append(valid!)

        if foundWords.count == words.count {
            winAction!()
            return
        }
    }

    func onWin(perform action: @escaping () -> Void) -> Self {
        var copy = self
        copy.winAction = action
        return copy
    }

    func updateDisplayWord() -> Void {
        self.curWord = selected.map({
            String(chars[$0.0][$0.1])
        }).joined()
    }

    var body: some View {
        let highlightingWord = DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($location) { (value, state, transaction) in
                    state = value.location
                }.onChanged { _ in
                    updateDisplayWord()
                }.onEnded {_ in
                    DispatchQueue.main.async {
                        validateSelection()
                        self.selected = []
                        self.highlighted = nil
                    }
                }
        VStack {
            HStack {
                Spacer()

                Text("Found " + String(foundWords.count) + "/" + String(words.count))
                Spacer()

                if selected.count > 0 {
                    Text(curWord.uppercased())
                    Spacer()
                }
            }
            .font(.title2)
            .foregroundColor(.white)
            .padding([.top, .bottom], 5)
            .background(Color.black.opacity(0.7))

            LazyVGrid(columns: gridColumns, spacing: 2, content: {
                ForEach((0..<(rowsNum * columnsNum)), id: \.self) { i in
                    let coord: (Int, Int) = (i / columnsNum, i % columnsNum)
                    let backgroundColor = self.rectReader(row: coord.0, column: coord.1)
                    Text(String(chars[coord.0][coord.1]).uppercased())
                            .fontWeight(self.selected.contains(where: {$0 == coord}) ? .bold : .none)
                            .padding(4)
                            .frame(minWidth: 25, maxWidth: 25, minHeight: 0, maxHeight: 200)
                            .foregroundColor(.white)
                            .background(backgroundColor)
                            .cornerRadius(5)
                            .scaleEffect(self.selected.contains(where: {$0 == coord}) ? 1.5 : 1)
                        .font(.system(size: 22))
                }
            })
            .gesture(highlightingWord)
            .padding([.top, .bottom], 10)
            .background(Color.orange.opacity(0.9))
            .cornerRadius(10.0)
            .padding([.trailing, .leading], 20)
        }
    }
}
