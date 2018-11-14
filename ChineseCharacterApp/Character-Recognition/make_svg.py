import sys
import re

def scale(points):
    # Scales from a ((0,0), (500,600)) canvas to a 500x500 canvas
    # if your project reuires you to understand my code, get

    NEW_DIM = 500 # Dimensions of standardized canvas
    IMG_PROP = .9 # Don't want it going all the way to the edge.

    max_x = max([x[0] for x in points])
    min_x = min([x[0] for x in points])
    max_y = max([y[1] for y in points])
    min_y = min([y[1] for y in points])

    scalar = IMG_PROP * NEW_DIM / max((max_x - min_x, max_y - min_y))

    midpoint = ((max_x + min_x) / 2, (max_y + min_y) / 2)

    return [(pt - midpoint[i % 2]) * scalar + NEW_DIM / 2 for i, pt in enumerate(points)]

def points_to_SVG(str):
    pass

class make_ctx:
    def __init__(self):
        self._stroke_num = 0
        self._strokes = []

    def curr(self):
        return self._strokes[-1]

    # def beginPath(self):
    #   pass

    # def stroke(self):
    #   pass

    def moveTo(self, x, y):
        self._strokes.append(["M", x, y])

    def bezierCurveTo(self, *argv):
        self.curr().append('C')
        for i,arg in enumerate(argv):

            # All but last 2 elements are control points; if not control points, if they're out of bounds throw an error
            if i <= len(argv) - 2:
                assert(arg < 500)

            self.curr().append(arg)

    def write_list(self, file):
        # For each stroke in the list, joins with spaces, to form a list of SVG paths
        # Write SVG paths to the file.
        file.write(str([' '.join([str(val) for val in stroke_str])
                            for stroke_str in self._strokes]))
        file.write('\n')

def main():
    args = sys.argv

    src_filename = args[1]
    dest_filename = 'strokes.txt'
    with open(src_filename, 'r') as src_file:
        with open(dest_filename, 'a') as dest_file:
            lines = [line[:-2] + '\n' for line in src_file.readlines()]
            svg_list = make_ctx()
            for line in lines:

                #Cleansing input
                if not re.match('^\s*ctx[.](moveTo|bezierCurveTo)', line):
                    continue

                # Evaluate a call of a ctx method with ctx as '
                eval(line, {'ctx':svg_list, 'xoff':0, 'yoff':0})
            svg_list.write_list(dest_file)

if __name__ == '__main__':
    main()

