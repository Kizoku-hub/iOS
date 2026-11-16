import SwiftUI

//Task2
class CampusPlace {
    let name: String
    init(name: String) {self.name = name}
    func visitMessage() -> String {
        "Visiting \(name)"
    }
}
/*
The shared property is name because every subclass inherits it from CampusPlace.
The method is visitMessage
*/

//Task3
class Classroom: CampusPlace {
    override func visitMessage() -> String {
        "Attend a lesson at \(name)"
    }
}
class Library: CampusPlace {
    override func visitMessage() -> String {
        "Read books at \(name)"
    }
}
class Laboratory: CampusPlace {
    override func visitMessage() -> String {
        "Conduct an experiment at \(name)"
    }
}

class SelfLearningRoom: CampusPlace {
    override func visitMessage() -> String {
        "Private self learning room \(name)"
    }
}
class ComputerRoom: CampusPlace {
    override func visitMessage() -> String {
        "Free computer for learning purposes at \(name)"
    }
}

//Task4
let places: [CampusPlace] = [
    Classroom(name: "Room A101"),
    Library(name: "Central Library"),
    Laboratory(name: "Physic Lab"),
    SelfLearningRoom(name: "Room K-K-K-K-Krazy")
    ComputerRoom(name: "Ollie desuuu")
]