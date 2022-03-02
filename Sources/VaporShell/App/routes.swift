/*
VaporShell provides a minimal framework for starting Igis projects.
Copyright (C) 2021, 2022 CoderMerlin.com
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import Vapor

func routes(_ app: Application) throws {
    let world = World()
    
    app.get { req in
        return "It works!"
    }


    app.put("putBlock", ":x", ":y", ":z", ":type") { req -> String in
        guard let x = req.parameters.get("x", as: Int.self) else {
            throw Abort(.badRequest)
        }
        guard let y = req.parameters.get("y", as: Int.self) else {
            throw Abort(.badRequest)
        }
        guard let z = req.parameters.get("z", as: Int.self) else {
            throw Abort(.badRequest)
        }
        
        guard let type = req.parameters.get("type", as: String.self) else {
            throw Abort(.badRequest)
        }
        world.setBlock(at:BlockPoint3d(x:x, y:y, z:z), to:type)
        return "Block at \(x), \(y), \(z) changed to \(type)"
    }

    app.get("getBlock") { req -> BlockData in
        guard let x = try? req.query.get(Int.self, at: "x") else {
            throw Abort(.badRequest)
        }
        guard let y = try? req.query.get(Int.self, at: "y") else {
            throw Abort(.badRequest)
        }
        guard let z = try? req.query.get(Int.self, at: "z") else {
            throw Abort(.badRequest)
        }
        if  y >= 0 && y < world.Blocks.count {
            if  x >= 0 && x < world.Blocks[y].count {
                if  z >= 0 && z < world.Blocks[y][x].count {
                    let block = world.Blocks[y][x][z]
                    return BlockData(block)
                } else {
                    throw Abort(.badRequest)
                }
            } else {
                throw Abort(.badRequest)
            }
        } else {
            throw Abort(.badRequest)
        }
    }
}
