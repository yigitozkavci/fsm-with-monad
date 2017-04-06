# What is this?
This is a small demonstration of a fsm with Haskell state monad. You can find the pure implementation [here](http://daniel-levin.github.io/2015/01/19/primitive-state-machine-in-haskell.html). Directed graph of the represented FSM is below.

![FSM Directed Graph](https://github.com/yigitozkavci/fsm-with-monad/blob/master/assets/fsm.png)

# Try it
Pull the repository and run:
```
$ cabal sandbox init
$ cabal install
$ cabal run
```
You can supply any string consisting of characters `a` and `b` to REPL that is opened when you run `cabal run`. It is context aware, meaning that the eventual result of the following two streams are the same:
```
> aaaab
False
> baaa
True
```
```
> aaaabbaaa
True
```

# LICENSE
[MIT LICENSE](https://github.com/yigitozkavci/fsm-with-monad/blob/master/LICENSE)
