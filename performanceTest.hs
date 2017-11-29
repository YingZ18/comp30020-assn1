--  File     : performanceTest.hs
--  Author   : David Stern
--  Origin   : Fri Aug 25 07:30:02 2017
--  Purpose  : Project 1 Testing, COMP30020, Declarative Programming
--  NOTE     : Adapts Peter Schachte's test code.

import Data.List
import System.Environment
import System.Exit
import Proj1
-- import Criterion.Measurement
-- import Criterion.Main

-- | Compute the correct answer to a guess.  First argument is the 
--   target, second is the guess.
response :: [String] -> [String] -> (Int,Int,Int)
response target guess = (right, rightNote, rightOctave)
  where guess'      = nub guess
        right       = length $ intersect guess' target
        num         = length guess'
        rightNote   = num - (length $ deleteFirstsBy (eqNth 0) guess' target) 
                    - right
        rightOctave = num - (length $ deleteFirstsBy (eqNth 1) guess' target) 
                    - right


-- | eqNth n l1 l2 returns True iff element n of l1 is equal to 
--   element n of l2.
eqNth :: Eq a => Int -> [a] -> [a] -> Bool
eqNth n l1 l2 = (l1 !! n) == (l2 !! n)


-- |Returns whether or not the chord passed in is a valid chord.  A
-- chord is valid if it is a list of exactly three valid pitches with 
-- no repeats.
validChord :: [String] -> Bool
validChord chord =
  length chord == 3 && nub chord == chord && all validPitch chord 

    
-- |Returns whether or not its argument is a valid pitch.  That is, it
-- is a two-character strings where the first character is between 'A'
-- and 'G' (upper case) and the second between '1' and '3'.
validPitch :: String -> Bool
validPitch note =
  length note == 2 && 
  note!!0 `elem` ['A'..'G'] && 
  note!!1 `elem` ['1'..'3']


test :: [[String]] -> Int
test (x:xs) = (run_test x + test xs)
test [] = 0

-- | Main program.  Gets the target from the command line (as three
--   separate command line arguments, each a note letter (upper case)
--   followed by an octave number.  Runs the user's initialGuess and
--   nextGuess functions repeatedly until they guess correctly.
--   Counts guesses, and prints a bit of running commentary as it goes.
run_test :: [String] -> Int
run_test args 
  | length args == 3 && validChord target = loop target guess other 1
  | otherwise                             = 0
  where
    target = args
    test = head args
    (guess,other) = initialGuess

loop :: [String] -> [String] -> Proj1.GameState -> Int -> Int
loop target guess other guesses
  | answer == (3,0,0) = guesses
  | otherwise         = loop target guess' other' (guesses+1)
  where
    answer = response target guess
    (guess',other') = nextGuess (guess,other) answer



------------------------------- AVERAGE SCORE -------------------------------
-- Current Average Score = 4.209022556390978
-- Compiled and performed all possible guesses in 52 secs.
-- TO USE:
-- (1) ghc performanceTest
-- (2) ./performanceTest
notes = [[note, octave] | note <- ['A'..'G'], octave <- ['1'..'3']]
allChords = [chord | chord <- subsequences notes, length chord == 3]

main = do
  let total = fromIntegral (test allChords)
  let avg = total / 1330
  putStrLn ("Average Score = " ++ show avg)


------------------ TEST PERFORMANCE (Execution time) ------------------------
-- REQUIREMENTS
-- cabal update
-- cabal install -j --disable-tests criterion
-- TO USE: 
-- (1) Un-comment import Criterion.Measurement and import Criterion.Main
-- (2) Comment out the main function above, used to calculate Average Score
-- (3) Un-comment the code below
-- (4) Re-Compile
-- (5) ./performanceTest

{-
printTest :: IO()
printTest = do
  -- putStrLn ("Test results: " ++ show (nf test allChords))
  let total = fromIntegral (test allChords)
  let avg = total / 1330
  putStrLn ("Average Score = " ++ show avg)


main = defaultMain [
      bgroup "test" [ bench "0" $ nf test allChords
                    , bench "1" $ nf test allChords 
                    ]
                  ]
-}

