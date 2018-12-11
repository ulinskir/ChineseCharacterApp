Important: Source = user-drawn stroke(s), target = correct stroke(s)


Character recognition:

Code for setting up and calling recognition is in ChineseCharacterApp/ViewControllers/DrawCharacterViewController

DrawingView (Views/DrawingView.swift) collects a list of Points and passes them to the runCharacterRecognition function in DrawCharacterViewController. Point is a type alias of (double, double) since Apple's CGPoints only use single-precision

The rest of the code is in files in ChineseCharacterApp/Views/Character-Recognition.

Main recognition code is in Match_Main.swift

1: Getting target points =============================================

Converting target SVG's to lists of points:
Matcher.ProcessTargetPoints takes the list of target SVG's and the dimensions of the canvas being converted to, in the form (North, South, East, West). It then uses the SvgPath class in SVGtoPath.swift to parse the SVG's and get a list of SVG commands. BezierPoints.get_points function in this file samples the SVG at a lot of points, then resamples them so that they are evenly spaced.

The resampling of the target points currently happens in SVGtoPath.
Resampler(Resampler.swift):
The only stuff I'm really using is at the very bottom. The code I got the resampler from is a full unistroke recognizer, but it's not usable for the app because it doesn't actually tell how close the user's stroke was, it just finds which of its stored gestures the user most likely were trying to draw.

The original resampler, which is called resampleLegacy in the code, seems to be bugged, since it should be giving you exactly the number of points you pass to it, but it gives less. I made my own, simple version which finds the ceiling of the ratio of how many points there are vs. how many points there should be and removes points (if there are ~twice as many points as there should be, it removes every other; if there are 3x as many, it removes all but every third, and so on, so forth). Currently this is only run on the target stroke.

2: Matching ========================================================================
Once the lists of lists of points have been obtained from source list source strokes are passed from the DrawingView, and converted to double-precision Points, they get passed to 
Matcher class has a function full_matcher which takes source and target points and returns a list of StrokeResults, which are defined at the top of the file, and a list of Ints which are the indices of strokes the strokes which the user drew that weren't recognized. 

2a: Linear Transformation: It shifts, scales and rotates the source so that it lines up with the target, but it will only rotate as much as the constant maxTransformAngle.
I think it is 

Recognizer.swift is exactly the same as it is in Inkstone, I just changed a couple of the constants, and the return type is slightly different. It recognizes if the source is partially in the target, not if the whole stroke is there, so I had to add a check. The function recog_ez just checks if the source and target begin near each other, although it returns a tuple of 2 bools, first to see if they are drawn near each other, and the second is checking correct direction, although it's currently unused.

For each source stroke, it goes through the target strokes that have not been found and compares it. It puts any matches in a list, and then selects the one that is physically closest to the source stroke.

The way order works is that the index of the source stroke has to match the index of the target stroke, and it cannot precede any stroke that was supposed to come before it.


 If it finds a match, it checks to see if the strokes start and end close enough to the same place. The FoundStroke type includes the stroke result, but also the

e.g. if strokes 3,2,1,4,5 were drawn in that order, stroke 2 would not be in order even though it was drawn second, because it was drawn before stroke 1.

A list of StrokeResults is passed to the runRecognizer in DrawCharacterViewController, and is parsed in the feedbackString function.