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

var roll = 0

while Array(players.map{ player in player.completed}).contains(false) {
    for player in players {
        if player.position < 170  {
        player.position += 

        
        }
    }
}
