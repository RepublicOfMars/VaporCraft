import Foundation

class Block {
    var location : BlockPoint3d //negative corner of the block
    var type : String

    init(location:BlockPoint3d, type:String) {
        self.location = location
        self.type = type
    }
}
