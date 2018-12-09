import sys
import re

ONE_CHAR = False
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
        self._strokes = []

    def __str__(self):
        return self.char_list_str()



    def curr(self):
        return self._strokes[-1]

    # def beginPath(self):
    #   pass

    # def stroke(self):
    #   pass

    def moveTo(self, x, y):
        self._strokes.append(["M", x, y])

    def lineTo(self, *argv):
        self.curr().append('L')
        for arg in argv[-2:]:
            assert(arg < 500)
            self.curr().append(arg)

    def bezierCurveTo(self, *argv):
        self.curr().append('C')
        for i,arg in enumerate(argv):

            # All but last 2 elements are control points; if not control points, if they're out of bounds throw an error
            if i <= len(argv) - 2:
                assert(arg < 500)

            self.curr().append(arg)

    def char_list_str(self):
        # For each stroke in the list, joins with spaces, to form a list of SVG paths
        # Write SVG paths to the file.
        result = ""
        result += (str([" ".join([str(val) for val in stroke_str])
                            for stroke_str in self._strokes]).replace("'",'"'))
        result += ('\n')
        return result

    def clear(self):
        self._strokes = []


# def make_one_char():
#     args = sys.argv

#     src_filename = args[1]
#     dest_filename = 'strokes.txt'
#     with open(src_filename, 'r') as src_file:
#         with open(dest_filename, 'a') as dest_file:
#             lines = [line[:-2] + '\n' for line in src_file.readlines()]
#             svg_list = make_ctx()
#             for line in lines:

#                 #Cleansing input
#                 if not re.match('^\s*ctx[.](moveTo|bezierCurveTo|lineTo)', line):
#                     continue
#                 eval(line, {'ctx':svg_list, 'xoff':0, 'yoff':0})

#                 # Evaluate a call of a ctx method with ctx as '
#             dest_file.write(str(svg_list))



def make_all_chars():
    args = sys.argv
    svg_list = make_ctx()

    src_filename = args[1]
    dest_filename = 'strokes.txt'

    def clearBuffer(title=''):
        title = title.strip().replace('#','', 1)
        if(str(svg_list) != '[]\n'):
            dest_file.write(str(svg_list))
        if(title != ''):
            dest_file.write(title + ':\n')

        svg_list.clear()
    with open(src_filename, 'r') as src_file:
        with open(dest_filename, 'a') as dest_file:
            lines = src_file.readlines()
            for line in lines:
                stripped = line.strip()
                if len(stripped) < 1:
                    continue

                elif stripped[0] == '#':
                    clearBuffer(stripped)
                
                else:
                    formatted_line = stripped.replace(';', '')
                    if not re.match('^\s*ctx[.](moveTo|bezierCurveTo|lineTo)', formatted_line):
                        continue
                    eval(formatted_line, {'ctx':svg_list, 'xoff':0, 'yoff':0})
            clearBuffer()







def main():
    make_all_chars()
    # if(ONE_CHAR):
    #     make_one_char()
    # else:
    #     make_all_chars()



if __name__ == '__main__':
    main()

