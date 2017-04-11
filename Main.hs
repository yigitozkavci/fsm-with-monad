{-# LANGUAGE LambdaCase #-}

import Control.Monad.Identity
import Control.Monad.State hiding (State)

{- Since state monad is only exposed with a transformer
 - and we don't need the transformer, we use transformer with
 - Identity monad.
 -}
type State s = StateT s Identity

{- A type synonym for convenience like typedef in c/cpp. -}
type FState a = State Int a

{- Start state, namely S0
-}
initState :: Int
initState = 0

{- Transition function. Signature in FSM convention instead is:
 - transite :: (a, s) -> s
 -}
transite :: Char -> FState ()
transite 'a' = modify $ \case
  0 -> 1
  1 -> 2
  2 -> 0
transite 'b' = modify $ \case
  0 -> 2
  1 -> 0
  2 -> 2
transite _ = error "This machine only recognises inputs 'a' and 'b'"

{- Runs a list of computations. Since this machine
 - is stateful, we can supply it strings like "abaab",
 - and it will consume it one by one.
 -}
runComputation :: String -> FState ()
runComputation [c] = transite c
runComputation (x:xs) = transite x >> runComputation xs

{- Based on given state, either accepts or rejects the given
 - state. Since it does not change the state, we can insert this
 - computation in anywhere between our actual transitions.
 -}
snapshot :: FState Bool
snapshot = gets $ \case
  2 -> True
  _ -> False

{- Repl loop. Basically takes strings and feeds it to
 - our state computation one by one.
 -}
loop :: Int -> IO ()
loop state = do
  stream <- getLine
  let (result, s') = runState (runComputation stream >> snapshot) state
  print result
  loop s'

main :: IO ()
main = loop initState
