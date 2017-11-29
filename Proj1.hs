--  File     : Proj1.hs
--  Author   : David Stern
--  Origin   : Fri Aug 25 07:30:02 2017
--  Purpose  : Project 1 Submission, COMP30020, Declarative Programming.

-- This file implements functions that define an agent that plays 'ChordProbe'. 
-- 
-- ChordProbe is a game where a 'composer' selects a 'Chord'. A Chord is a list
-- of three distinct 'pitches'. A pitch is a String with a note ('A'..'G'),
-- and an Octave ('1'..'3'). The 'performer', the role of this agent, is to
-- guess the Chord, via repeated guesses, informed by feedback in the form of
-- a 'Score'. The 'score' function details this feedback.
-- 
-- This agent solves this problem via generating every possible chord & pruning
-- this list via selecting guesses that prune this game state as much as 
-- possible. This is explained above functions 'bestGuess' and 'getAvgRemCands'

module Proj1 (initialGuess, nextGuess, GameState) where

import Data.List

-- | Chord represents a list of 'pitches', GameState is simply a list of 
--   remaining possible chords, and Score is the scoring format defined by the
--   project specification.
type Chord     = [String]
type GameState = [Chord]
type Score     = (Int, Int, Int)


-- | Generates an initial guess, and a new game state enumerating every
--   possible guess, minus the guessed chord.
--   The initial guess is an empirically tested first guess, designed to
--   eliminate the most possible guesses (on average).
initialGuess :: (Chord, GameState)
initialGuess = (guess, state)
    where
        notes = [[note, octave] | note <- ['A'..'G'], octave <- ['1'..'3']]
        allChords = [chord | chord <- subsequences notes, length chord == 3]
        guess = ["A2", "B1", "C1"]
        state = allChords \\ [guess]


-- | Prunes the game state such that only chords that would have resulted in
--   the same score for our previous guess are included. 
--   Based on this updated state, the next guess is generated.
nextGuess :: (Chord, GameState) -> Score -> (Chord, GameState)
nextGuess (lastGuess, state) score = (nextGuess', state')
    where
        state' = delete lastGuess [ cord 
                                  | cord <- state
                                  , getScore cord lastGuess == score]
        nextGuess' = bestGuess state'


-- | Generates the 'best' possible guess, given a game's state (the possible
--   remaining chords). 'Best' is defined as the guess that when chosen will
--   (on average) result in the lowest number of remaining candidates, if it's
--   incorrect. To clarify, it reduces the no. of remaining possible chords by
--   the greatest amount, and therefore provides the highest amount of 
--   information.
bestGuess :: GameState -> Chord
bestGuess state = fst $ head bestguess
    where
        targRemCands = [(targ, remcands)
                       | targ <- state
                       , let state' = state \\ [targ]
                       , let remcands = getAvgRemCands targ state']
        bestguess = sortBy sndEl targRemCands


-- | Generates the average number of candidates that will remain after the
--   guess is discovered to be incorrect. Thus, this provides a reflection of
--   how effective the guess is at reducing the number of possible states.
--
--   Process:
--   Given a possible target chord, and the existing state at the time the
--   guess is to be made, it first generates a list of possible scores for the
--   given possible target, then sorts and groups these scores, and counts
--   the total number of tested targets. 
--   This information is used to calculate an average number of remaining
--   candidates after such a guess, the lower the number the better the guess
--   prunes the game state, on average.
--   
--   Average = sum of all (chanceOfOutcome * Outcome's remaining candidates)
--   Chance of each outcome is merely the number times this outcome can occur,
--   out of all of the possible outcomes.
getAvgRemCands :: Chord -> GameState -> Double
getAvgRemCands possTarget state
    = sum [(numOutcomes / totalOutcomes) * numOutcomes
          | grp <- grouped
          , let numOutcomes = (fromIntegral . length) grp]
    where
        scores  = [ans | guess <- state, let ans = getScore possTarget guess]
        grouped = (group . sort) scores
        totalOutcomes = (fromIntegral . length) scores
        

--  | An Ordering that is used to order tuples of remaining guesses and their
--    average number of remaining candidates, by the average number of
--    remaining candidates. Polymorphic type, so works with other tuples where
--    the second element is orderable.
--    The less-than tuple's second element is <= the other tuple's 2nd element.
sndEl :: (Ord b) => (a, b) -> (a, b) -> Ordering
sndEl x y
    | snd x <= snd y  = LT
    | otherwise       = GT


-- | Calculate the accuracy, the 'score' of a given guess chord for a given
--   target chord. The first argument is the target chord, the second is the
--   guess cord.
--   Understanding the Score:
--   Correct Pitches: How many pitches in the guess are included in the target
--   Correct Notes: How many pitches have the right note but the wrong octave
--   Correct Octaves: How many pitches have the right octave but the wrong note
getScore :: Chord -> Chord -> Score
getScore target guess = (numCorrect, correctNotes, correctOctaves)
    where 
        guess'          = nub guess
        numCorrect      = length $ intersect guess' target
        numPitches      = length guess'
        (note, chord)   = (0, 1)
        correctNotes    = numPitches 
                        - length (deleteFirstsBy (hasSame note) guess' target)
                        - numCorrect
        correctOctaves  = numPitches 
                        - length (deleteFirstsBy (hasSame chord) guess' target)
                        - numCorrect


-- | hasSame n listOne listTwo returns True iff element n of listOne is equal  
--   to (the same as) element n of listTwo.
hasSame :: Eq a => Int -> [a] -> [a] -> Bool
hasSame n listOne listTwo = (listOne !! n) == (listTwo !! n)
