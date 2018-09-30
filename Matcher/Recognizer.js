/*
 *  Copyright 2016 Shaunak Kishore (kshaunak "at" gmail.com)
 *
 *  This file is part of Inkstone.
 *
 *  Inkstone is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Inkstone is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Inkstone.  If not, see <http://www.gnu.org/licenses/>.
 */

const kAngleThreshold = Math.PI / 5;
const kDistanceThreshold = 0.3;
const kLengthThreshold = 1.5;

// Number of segments you're actually allowed to skip
const kMaxMissedSegments = 1;
const kMaxOutOfOrder = 2;

// Constant for how much distance in desired stroke location is allowable
const kMinDistance = 1 / 16;

const kMissedSegmentPenalty = 1;
const kOutOfOrderPenalty = 2;
const kReversePenalty = 2;

const kHookShapes = [[[1, 3], [-3, -1]], [[3, 3], [0, -1]]];

const util = {

  // distance squared
  distance2: (point1, point2) => util.norm2(util.subtract(point1, point2)),


  clone: (point) => [point[0], point[1]],

  // Square a vector
  norm2: (point) => point[0]*point[0] + point[1]*point[1],

  // Round 2 points
  round: (point) => point.map(Math.round),

  //Find the difference between 2 points
  subtract: (point1, point2) => [point1[0] - point2[0], point1[1] - point2[1]],
};

const angleDiff = (angle1, angle2) => {
  // Find difference of two angles

  const diff = Math.abs(angle1 - angle2);


  return Math.min(diff, 2 * Math.PI - diff);
}

const getAngle = (median) => {
  // Median is a set of points. Get the overall angle by subtracting the first point from the last
  const diff = util.subtract(median[median.length - 1], median[0]);
  return Math.atan2(diff[1], diff[0]);
}

const getBounds = (median) => {
  const min = [Infinity, Infinity];
  const max = [-Infinity, -Infinity];
  median.map((point) => {
    min[0] = Math.min(min[0], point[0]);
    min[1] = Math.min(min[1], point[1]);
    max[0] = Math.max(max[0], point[0]);
    max[1] = Math.max(max[1], point[1]);
  });
  return [min, max];
}

const getMidpoint = (median) => {
  const bounds = getBounds(median);
  return [(bounds[0][0] + bounds[1][0]) / 2,
          (bounds[0][1] + bounds[1][1]) / 2];
}

const getMinimumLength = (pair) =>
    // Gets distance between source and target, then adds kMinDistance
    Math.sqrt(util.distance2(pair[0], pair[1])) + kMinDistance;


const hasHook = (median) => {
  // determine if the stroke is supposed to have a hook?
  if (median.length < 3) return false;
  if (median.length > 3) return true;
  // for shape in kHookShapes:
  for (let shape of kHookShapes) {
    if (match(median, shape)) return true;
  }
  return false;
}

const match = (median, shape) => {
  if (median.length !== shape.length + 1) return false;
  for (let i = 0; i < shape.length; i++) {
    const angle = angleDiff(getAngle(median.slice(i, i + 2)),
                            getAngle([[0, 0], shape[i]]));
    if (angle >= kAngleThreshold) return false;
  }
  return true;
}

const performAlignment = (source, target) => {
  // Calculating difference between desired stroke and user-inputted stroke


  // Deep copies of source and target
  source = source.map(util.clone);
  target = target.map(util.clone);

  // a list where the first element is
      // a list from 0 to length of source, where the first element is 0 and the rest are -infinity
      // Gets rows pushed onto it

  // A 0 and a bunch of -(infinity)
  const memo = [_.range(source.length).map((j) => j > 0 ? -Infinity : 0)];

  // i iterates through target points4
  // For every single point in the target, compares to every combination of 2 source points
  for (let i = 1; i < target.length; i++) {

    const row = [-Infinity];

    // j iterates through source points
    for (let j = 1; j < source.length; j++) {

      // Starting with minimum
      let best_value = -Infinity;

      const start = Math.max(j - kMaxMissedSegments - 1, 0);

      // k iterates through all previous points to the jth point in source
      // Best_value is the score of the best scoring (most similar to target points) pair of point j and a point before point j
      for (let k = start; k < j; k++) {

        // Condition for skipping score pairing (-infinity in the corresponding element of memo)

        // Why are they comparing to the kth thing if the rows are added based on the j loop???????

        // Looking at the score of the comparison of the source points up to k and the previous target point 


        if (memo[i - 1][k] === -Infinity) continue;

        // memo[i - 1][k] is the score of the points up to the previous target point and up to the first source point that is getting checked

        const score = scorePairing(
          // Compares the two points in the source to two adjacent points of target
            [source[k], source[j]], [target[i - 1], target[i]], i === 1);

        const penalty = (j - k - 1) * kMissedSegmentPenalty;

        // looking at the previous row of memo, and passing on the best score if it's better than the score for this row

        // Setting the best value to the maximum of (the previous source point combination)
            // and the sum of the score pairing of the these two source points to the current target point
            // and its cumulative comparison to all the previous target points 
        best_value = Math.max(best_value, score + memo[i - 1][k] - penalty);
      }
      row.push(best_value);
    }
    memo.push(row);
  }
  const result = {score: -Infinity, source: null, target: null, warning: null};

  // is either target.length or target.length - 1
  const min_matched = target.length - (hasHook(target) ? 1 : 0);

  // Read memo table and get scores
  for (let i = min_matched - 1; i < target.length; i++) {

    // penalty for how far from the end your current best score is.
    const penalty = (target.length - i - 1) * kMissedSegmentPenalty;

    // for each value of i that was matched, take the last column of memo
    const score = memo[i][source.length - 1] - penalty;

    
    if (score > result.score) {
      result.penalties = 0;
      result.score = score;
      result.source = [source[0], source[source.length - 1]];
      result.target = [target[0], target[i]];
      result.warning = i < target.length - 1 ? 'Should hook.' : null;
    }
  }
  return result;
}

const recognize = (source, target, offset) => {
  // checks for stroke and reverse stroke

  if (offset > kMaxOutOfOrder) return {score: -Infinity};

  // Perform alignment and check score
  let result = performAlignment(source, target);

  // if it sucks, see if they did the stroke in reverse
  if (result.score === -Infinity) {
    let alternative = performAlignment(source.slice().reverse(), target);

    // yell at them
    if (!alternative.warning) {
      result = alternative;
      result.penalties += 1;
      result.score -= kReversePenalty;
      result.warning = 'Stroke backward.';
    }
  }
  result.score -= Math.abs(offset) * kOutOfOrderPenalty;
  return result;
}

const scorePairing = (source, target, is_initial_segment) => {

  // Angle offset
  const angle = angleDiff(getAngle(source), getAngle(target));

  // Distance between midpoints
  const distance = Math.sqrt(util.distance2(
      getMidpoint(source), getMidpoint(target)));

  // length ratio with abs(ln(x)) done to make the inputs make sense (just go with it)
  const length = Math.abs(Math.log(
      getMinimumLength(source) / getMinimumLength(target)));

  // If angle or distance or length are beyond the threshold, returns -infinity
  if (angle > (is_initial_segment ? 1 : 2) * kAngleThreshold ||
      distance > kDistanceThreshold || length > kLengthThreshold) {
    return -Infinity;
  }
  // Return the negative sum of the differences between angle, distance, and length
  return -(angle + distance + length);
}

export {match, recognize};