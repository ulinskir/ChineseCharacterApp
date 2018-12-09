# Fall 2018 Senior Seminar Chinese Character Recogniton
# Tom Parker
#
# Parses strokes.txt produced by make_svg.py. Returns the non-control points, i.e. in the second
#   line, returns the ordered pairs before a C and the last ordered pair in each string.
# !! This file is unfinished. It only returns the ordered pairs before a C. This is because !!
# !! plan A was completed during the process of writing this file.                          !!

import sys
import string

def main():

    # Need to return print a list of ordered pairs, so ((x,y), (x,y), x,y))

    # File Setup
    args = sys.argv
    srcPath = args[1]
    destPath = 'points.txt'
    if srcPath != 'strokes.txt':  # Exit if input file not made by make_svg.py
        exit(1)
    
    # Open files and isolate the second line of strokes.txt
    with open(srcPath, 'r') as src:
        with open(destPath, 'w') as dest:
            src.readline() # Throw away irrelevant first line
            data = src.readline()

            # Parse
            output = '['

            # Adds ordered pairs before a 'C' to output and add last ordered pair in each string
            prevCPos = 2 # starts on X, ['X ...
            for i, char in enumerate(data):

                # Adds ordered pairs before current 'C'
                if char == 'C':
                    # Isolate chars since the previous C
                    cData = data[prevCPos+1:i]

                    # Cut off data until all that remains is the numbers preceding the current C
                    # i.e loop through cData to an ASCII uppercase, remove all prior chars, repeat.
                    for j, ch in enumerate(cData):
                        if ch in string.ascii_uppercase:
                            cData = cData[j+2:i]

                    # Reformat
                    for j, word in enumerate(cData.split()):
                        if j % 2 == 0: # If even index
                            output += "(" + word + ", "
                        else:          # If odd
                            output += word + ")"
                    output += ", "

                    prevCPos = i

                # # Adds ordered pair just pair current ','
                # if char == '\'' and (data[i+1] == ',' or data[i+1] == ']'):

            output = output[0:len(output) - 2]
            output += ']'

            print(output, file = dest)


if __name__ == "__main__": 
    main()