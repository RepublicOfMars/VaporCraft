import Vapor
import Fluent

public final class BlockData : Content, Codable {
    let x : Int
    let y : Int
    let z : Int
    let type : String

    init(_ block:Block) {
        self.x = block.location.x
        self.y = block.location.y
        self.z = block.location.z
        self.type = block.type
    }
}
