import Foundation

func degToRad(_ deg:Double) -> Double {
    return Double(deg) * (Double.pi/180.0)
}

class Point3d {
    var x : Double
    var y : Double
    var z : Double

    init(x:Double, y:Double, z:Double) {
        self.x = x
        self.y = y
        self.z = z
    }

    func distanceFrom(point:Point3d) -> Double { //returns distance from a given point
        return sqrt((self.x-point.x)*(self.x-point.x)+(self.y-point.y)*(self.y-point.y)+(self.z-point.z)*(self.z-point.z))
    }

    func convertToBlock() -> BlockPoint3d {
        return BlockPoint3d(x:Int(self.x), y:Int(self.y), z:Int(self.z))
    }
}

class BlockPoint3d { //Used for blocks. when converting to normal Point3d, adds 0.5 to each axis
    var x : Int
    var y : Int
    var z : Int

    init(x:Int, y:Int, z:Int) {
        self.x = x
        self.y = y
        self.z = z
    }

    func convertToDouble() -> Point3d {
        return Point3d(x:Double(x)+0.5, y:Double(y)+0.5, z:Double(z)+0.5)
    }

    func isEqual(to:BlockPoint3d) -> Bool {
        if self.x == to.x && self.y == to.y && self.z == to.z {
            return true
        }
        return false
    }
}
