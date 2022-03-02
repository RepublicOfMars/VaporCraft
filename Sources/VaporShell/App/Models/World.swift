import Foundation

class World {
    var Blocks : [[[Block]]]
    let worldSize : (horizontal:Int, vertical:Int)
    let seed : Int

    var blocksGenerated = 0
    let blocksToGenerate : Int
    var lastPrintedPercent = 0
    
    var generating = true
    var blockGenerating = (x:0, z:0)
    
    init(seed:Int=0) {
        Blocks = []
        self.seed = seed
        self.worldSize = (horizontal:128, vertical:64)

        for y in 0 ..< worldSize.vertical {
            Blocks.append([])
            for _ in 0 ..< worldSize.horizontal {
                Blocks[y].append([])
            }
        }
        blocksToGenerate = worldSize.horizontal * worldSize.horizontal * worldSize.vertical

        print("Generating World \nwidth: \(worldSize.horizontal) \nheight: \(worldSize.vertical))")
        sleep(1)
        self.generateWorld()
        print("100%, World Generation Successful!")
    }

    private func inBounds(_ point:BlockPoint3d) -> Bool {
        let fixedPoint = point
        if fixedPoint.x >= worldSize.horizontal {
            return false
        }
        if fixedPoint.x < 0 {
            return false
        }
        if fixedPoint.y >= worldSize.vertical {
            return false
        }
        if fixedPoint.y < 0 {
            return false
        }
        if fixedPoint.z >= worldSize.horizontal {
            return false
        }
        if fixedPoint.z < 0 {
            return false
        }
        return true
    }

    private func horizontalInBounds(_ n:Int) -> Int {
        var horizontalPosition = n
        if horizontalPosition >= worldSize.horizontal {
            horizontalPosition = worldSize.horizontal - 1
        }
        if horizontalPosition < 0 {
            horizontalPosition = 0
        }
        return horizontalPosition
    }

    private func verticalInBounds(_ n:Int) -> Int {
        var verticalPosition = n
        if verticalPosition >= worldSize.vertical {
            verticalPosition = worldSize.vertical - 1
        }
        if verticalPosition < 0 {
            verticalPosition = 0
        }
        return verticalPosition
    }

    private func generate(x:Int, z:Int) {
        let terrainHeight = 32 + Int(8.0*(Noise(x:x, z:z, seed:seed)))
        
        for y in 0 ..< worldSize.vertical {
            var type = "air"
            if y <= terrainHeight-3 {
                type = "stone"
                if y <= 8 && Int.random(in:1...128) == 1 {
                    type = "diamond_ore"
                }
                if y <= 16 && Int.random(in:1...64) == 1 {
                    type = "iron_ore"
                }
                if y <= 24 && Int.random(in:1...32) == 1 {
                    type = "coal_ore"
                }
            } else if y <= terrainHeight-1 {
                type = "dirt"
            } else if y <= terrainHeight {
                type = "grass"
            }
            
            if y <= 0 {
                type = "bedrock"
            }
            
            Blocks[y][x].append(Block(location:BlockPoint3d(x:x, y:y, z:z), type:type))
            blocksGenerated += 1
        }
    }
    
    public func getBlock(at:BlockPoint3d) -> Block {
        return Blocks[verticalInBounds(at.y)][horizontalInBounds(at.x)][horizontalInBounds(at.z)]
    }
    
    public func setBlock(at:BlockPoint3d, to:String) {
        Blocks[verticalInBounds(at.y)][horizontalInBounds(at.x)][horizontalInBounds(at.z)].type = to
    }
    
    private func createTree(at:BlockPoint3d) {
        let trunkHeight = Int.random(in:3...5)
        //create leaves
        for x in -2 ... 2 {
            for z in -2 ... 2 {
                for y in -2 ... -1 {
                    setBlock(at:BlockPoint3d(x:at.x+x, y:at.y+y+trunkHeight, z:at.z+z), to:"leaves")
                }
            }
        }
        for x in -1 ... 1 {
            for z in -1 ... 1 {
                for y in 0 ... 1 {
                    setBlock(at:BlockPoint3d(x:at.x+x, y:at.y+y+trunkHeight, z:at.z+z), to:"leaves")
                }
            }
        }
        
        //create trunk
        for y in 0 ..< trunkHeight {
            setBlock(at:BlockPoint3d(x:at.x, y:at.y+y, z:at.z), to:"log")
        }
    }
    
    private func generateWorld() {
        //generation
        while generating {
            generate(x:blockGenerating.x, z:blockGenerating.z)

            if blockGenerating.z == 0 {
                if (blocksGenerated*100)/blocksToGenerate != lastPrintedPercent {
                    lastPrintedPercent = (blocksGenerated*100)/blocksToGenerate
                    if blocksGenerated > 1_000_000 {
                        print("\(lastPrintedPercent)%, \(Double(blocksGenerated/100_000)/10) Million blocks generated")
                    } else if blocksGenerated > 1_000 {
                        print("\(lastPrintedPercent)%, \(Double(blocksGenerated/100)/10) Thousand blocks generated")
                    } else {
                        print("\(lastPrintedPercent)%, \(blocksGenerated) blocks generated")
                    }
                }
            }
            
            blockGenerating.z += 1
            if blockGenerating.z >= worldSize.horizontal {
                blockGenerating.z = 0
                blockGenerating.x += 1
            }
            if blockGenerating.x >= worldSize.horizontal {
                for _ in 0 ..< 128 {
                    let treeLocation = (x:Int.random(in:0..<worldSize.horizontal), z:Int.random(in:0..<worldSize.horizontal))
                    createTree(at:BlockPoint3d(x:treeLocation.x, y:33 + Int(8.0*(Noise(x:treeLocation.x, z:treeLocation.z, seed:seed))), z:treeLocation.z))
                }
                generating = false
            }
        }
    }
}
