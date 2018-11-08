import sys
import JSON

def scale(points):
	# Scales from a ((0,0), (500,600)) canvas to a 500x500 canvas
	# if your project reuires you to understand my code, get

	NEW_DIM = 500 # Dimensions of standardized canvas
	IMG_PROP = .9 # Don't want it going all the way to the edge.

	max_x = max([x[0] for x in points])
	min_x = min([x[0] for x in points])
	max_y = max([y[1] for y in points])
	min_y = min([y[1] for y in points])

	scalar = IMG_PROP * NEW_DIM / max((max_x - min_x, max_y - min_y))

	midpoint = ((max_x + min_x) / 2, (max_y + min_y) / 2)

	return [(pt - midpoint[i % 2]) * scalar + NEW_DIM / 2 for i, pt in enumerate(points)]

def points_to_SVG(str):
	pass

class make_ctx:
	def __init__(self, dest_file):
		self._stroke_num = 0
		self._strokes = []

	def curr(self):
		return self._strokes[-1]

	def beginPath(self):
		pass

	def stroke(self):
		pass

	def moveTo(self, x, y):
		self._strokes.append([])
		self.curr() += ["M", (scale(x)), (scale(y))]

	def bezierCurveTo(self, *argv):
		self.curr().append('C')
		for arg in argv:
			self.curr().append(scale(argv))

def main():
	args = sys.argv

	src_filename = args[1]

	with src_path  = open(src_filename, 'r'):
		with dest_path = open(dest_filename, 'a'):
			lines = src_file.readlines()
			ctx = make_ctx()
			for line in lines[1:-1]:
				eval(line, {'ctx':ctx, 'xoff':0, 'yoff':0})
		