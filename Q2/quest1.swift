class Player {

    var position: Int = 0
    var playerNumber: Int?
    var diceRolls: [Int] = []
    var points = 0

    init(_ playerNumber: Int , _ diceRolls: [Int]) {
        self.playerNumber = playerNumber
        self.diceRolls = diceRolls
    }

    var completed: Bool = false

}

var players: [Player] = []
players.append(Player(1,[2,4,5,6]))
players.append(Player(2,[1,3,4,6]))
players.append(Player(3,[1,2,3,5]))
players.append(Player(4,[1,2,3,6]))

var roll: Int = 0

while Array(players.map{ player in player.completed}).contains(false) {
    for player in players {
        if !player.completed  {
            player.position += player.diceRolls[roll]
            if player.position >= 170 {
                player.completed = true
                continue
            } else {
                if player.position % 3 == 0 {
                    if player.position % 5 == 0 {
                        player.points -= 4 
                        player.position -= 2  
                    }
                    else if player.position % 2 == 0 {
                        player.points += player.position / 6
                        
                    }
                } 
                else if player.position % 5 == 0 { 
                    player.points += player.position / 5 + 7
                }
            }
        }
    }
    let playerPositions: [Int] = Array(players.map{ myPlayer in myPlayer.position})
    for index in 0..<4 {
        if Array(playerPositions[..<index] + playerPositions[(index + 1)...]).contains(players[index].position) {
            players[index].points += 5
        }
    }
    print("Positions of players are \(playerPositions)")
    print("Points of players are \(Array(players.map{ myPlayer in myPlayer.points}))")
    roll += 1
    roll %= 4
}

players = players.sorted(by: { $0.points > $1.points })

var winners: [Player] = Array(players.filter{ player in player.points == players[0].points})

print()

print("Winners of the game are: : ")

for player in winners {
    print("Player \(player.playerNumber!)")
}

print()

print("Positions of team are (According to their rank) : : ")

for player in players {
    print("Player \(player.playerNumber!) is at position \(player.position) with total points of \(player.points)" )
}