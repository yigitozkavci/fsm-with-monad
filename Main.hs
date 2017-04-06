import Control.Monad.Identity
import Control.Monad.State hiding (State)

{- Since state monad is only exposed with a transformer
 - and we don't need the transformer, we use transformer with
 - Identity monad.
 -}
type State s = StateT s Identity

{- Our FState can generate side effects (like `decide` does) or not
 - (like `transite` does). `a` in the type constructor is the side effect
 - and Int part in the data constructor is the state id.
 -}
type FState a = State Int a

{- Start state, namely S0
-}
initState :: Int
initState = 0

{- Transition function. Signature in FSM convention instead is:
 - transite :: (a, s) -> s
 -}
transite :: Char -> FState ()
transite 'a' = modify $ \s ->
  case s of
    0 -> 1
    1 -> 2
    2 -> 0
transite 'b' = modify $ \s ->
  case s of
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
decide :: FState Bool
decide = gets $ \s ->
  case s of
    2 -> True
    _ -> False

{- Repl loop. Basically takes strings and feeds it to
 - our state computation one by one.
 -}
loop :: Int -> IO ()
loop state = do
  stream <- getLine
  let (result, s') = runState (runComputation stream >> decide) state
  print result
  loop s'

main :: IO ()
main = loop initState