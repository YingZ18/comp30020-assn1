# comp30020-assn1
Assignment 1 for COMP30020 - Declarative Programming, a 'Chord' guessing game written in Haskell

# Overview

This is completed code for project 1 for the University of Melbourne subject COMP30020 - Declarative Programming. The aim to is to write Haskell code which can implement the guessing part of a logical guessing game, described below. We want to write code which guesses the correct solution in as few guesses as possible, and is as efficient as possible. 

# Running
Compile using `ghc -O2 --make Proj1Test`. To run `Proj1Test`, give it the target as three separate command line arguments, for example `./Proj1Test D1 B1 G2` would search for the target `["D1", "B1", "G2"]`. It will then use the `Proj1` module to guess the target; the output will look something like:
```
Your guess 1:  ["A1","B1","C2"]
My answer:  (1,0,2)
Your guess 2:  ["A1","D1","E2"]
My answer:  (1,0,2)
Your guess 3:  ["A1","F1","G2"]
My answer:  (1,0,2)
Your guess 4:  ["B1","D1","G2"]
My answer:  (3,0,0)
You got it in 4 guesses!
```

# performanceTest.hs
Calculates average score for every possible guess, and tests performance (execution speed) using the Criterion library. Follow the comments in the script to run.

# The Game of ChordProbe
ChordProbe is a two-player logical guessing game created for this project. You will not find any information about the game anywhere else, but it is a simple game and this specification will tell you all you need to know.

For a ChordProbe game, one player will be the composer and the other is the performer. 
The composer begins by selecting a three-pitch musical chord, where each pitch comprises a musical note, one of A, B, C, D, E, F, or G, and an octave, one of 1, 2, or 3. This chord will be the target for the game. The order of pitches in the target is irrelevant, and no pitch may appear more than once. This game does not include sharps or flats, and no more or less than three notes may be included in the target.

Once the composer has selected the target chord, the performer repeatedly chooses a similarly defined chord as a guess and tells it to the composer, who responds by giving the performer the following feedback:

1. how many pitches in the guess are included in the target (correct pitches)
2. how many pitches have the right note but the wrong octave (correct notes)
3. how many pitches have the right octave but the wrong note (correct octaves)

In counting correct notes and octaves, multiple occurrences in the guess are only counted as correct if they also appear repeatedly in the target. Correct pitches are not also counted as correct notes and octaves. For example, with a target of A1, B2, A3, a guess of A1, A2, B1 would be counted as 1 correct pitch (A1), two correct notes (A2, B1) and one correct octave (A2). B1 would not be counted as a correct octave, even though it has the same octave as the target A1, because the target A1 was already used to count the guess A1 as a correct pitch. A few more examples:

| Target        | Guess         | Answer|
| ------------- |:-------------:|:-----:|
| A1,B2,A3      | A1,A2,B1      | 1,2,1 |
| A1,B2,C3      | A1,A2,A3      | 1,0,2 |
| A1,B1,C1      | A2,D1,E1      | 0,1,2 |
| A3,B2,C1      | C3,A2,B1      | 0,3,3 |

The game finishes once the performer guesses the correct chord (all three pitches in the guess are in the target). The object of the game for the performer is to find the target with the fewest possible guesses.

# Assessment
Full marks were given for an average of 4.3 guesses per target, with marks falling on a logarithmic scale as the number of guesses rises. Thus moving from taking 5 guesses to 4 will gain similar number of points as going from 7 to 5 guesses. Therefore as the number of guesses drops, further small decreases in the number of guesses are increasingly valuable.
Note that timeouts will be imposed on all tests. You will have at least 5 seconds to guess each target, regardless of how many guesses are needed. Executions taking longer than that may be unceremoniously terminated, leading to that test being assessed as failing. Your programs will be compiled with GHC -O2 before testing, so 5 seconds per test is a very reasonable limit.

# Results
Final Mark: 100%
Correctness: 70/70 || Code style: 30/30
See Feedback.txt for a full description of the results.