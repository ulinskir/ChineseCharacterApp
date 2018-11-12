convert_points.swift

typealias Edges (north:NSDecimalNumber, south:NSDecimalNumber, east:NSDecimalNumber, west:NSDecimalNumber)

class make_fn {
	func make_canvas_dimension_converter(from:Edges, to: Edges) -> (Point) -> Point {

		let src_canvasSize = min(from.south - from.north, from.west - from.east)
		let dest_canvasSize = min(to.south - to.north, to.west - to.east)

		let src_midpoint: Point = (Double(from.east + from.west) / 2, Double(from.south + from.north) / 2)
		let dest_midpoint: Point = (Double(to.east + to.west) / 2, Double(to.south + to.north) / 2)

		let scalar:Double = Double(src_canvasSize) / Double(dest_canvasSize)
		
		func converter(_ src_point:Point) -> Point {
			(scalar * (src_point - src_midpoint) + dest_midpoint)
		}
		return converter
	}
}