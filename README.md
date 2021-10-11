# FIT2102, Semester 2, 2021, Assignment 2: TwentyOne

 - **Due Date**: 23:55, October 24^th, 2021
 - **Weighting**: 30% of your final mark for the unit
 - **Uploader**: <https://www.fit2102.monash/uploader/>
 - **Overview**: Your goal is to implement a player for the game of TwentyOne.
   Your player needs to be able to play a valid game; manage a "memory" string
   with a parser-combinator; and, leverage concepts from the course. You will
   also need to write a two-page-report describing your submission.
 - **Building and using the code**: The code bundle is packaged the same way as
   tutorials. To compile the code, run: `stack build`. To execute the code,
   run: `stack exec staticgame`. If you want to play with more players, you will
   need to edit `staticgame/Main.hs`. You cannot edit the `stack` configuration.
 - **Submission**: Your player source code and your report in PDF format go in
   the `submission/` folder of the code bundle. To submit you will zip up *just
   the contents of this `submission/` folder* into one file named
   `studentNo_name.zip`.

## TwentyOne

TwentyOne consists of *numPlayers* players and a dealer where the objective
is to finish the game with the most points. Points are awarded to all
players whose hand outperforms the dealer's hand. The amount of points awarded will depend
on the amount you bid.

Your task for this assignment is to implement a player able to play a
non-trivial game of TwentyOne - by non-trivial we mean the player makes some sort of effort to play to win. We will use three decks of 52 playing cards.

## Rules

The object of the game is to get the hand value as close as possible to '21'. Numeric Cards (2-9)
are worth the numeric value in points. Face cards are worth 10. Aces can be either high (11)
or low (1). Aces will take the highest value possible, as long as the total value does not go above '21'.

For example:

**A♠ 2♠ 3♠** is worth 16. Ace will be high.

**A♠ 9♠ 10♠** is worth 20. Ace will be low. If the Ace is high, the value will above 21, therefore,
the Ace assumes 1.

The rules of the game are described below.

### Before the Game
- At the start of each game - each player will receive a starting balance of *startingPoints*
- The dealer will shuffle three decks of cards to be in use. This will be used
  in a continuous manner until all cards have been dealt out. Once all cards have been dealt,
  three new decks will be shuffled and the game will be continued

### Before Each Hand
- Each player will place a bid. This bid can range between *minBid* and *maxBid*
- The order of the players will be randomized.
- Each player will  be dealt two cards face down (they are not revealed yet).
- Each player will see a singular 'up card' of the dealer.

The default values of these variables are shown below. However, these will be changed for the marking (see BotMarking) - so a good player should be able to adapt to slightly different setups of the game.

|   Parameter    | Value |
| :------------: | :---: |
|     minBid     |  10   |
|     maxBid     | 1000  |
| startingPoints | 10000 |
|   numPlayers   |  10   |


### During Each Hand
- Each player will take a turn playing a hand. This will be in the same order as the bidding round.
- The player has 4 options of play in their turn: Hit, Stand, DoubleDown, Split, and Insurance.
  - **Hit**: The player receives another card from the deck.
  - **Stand**: The player ends their turn.
  - **DoubleDown**: The player doubles their bid. After the double down, the user must Hit and then Stand over the next two turns.
  - **Split**: If the player has pairs (two cards of the same rank, e.g two sixes or two Jacks). The player can choose to split the hand in to two hands, with one of each pair into each of the hands. The amount of the original bid will go on to both hands. The player will then play out both hands separately.
  - **Insurance**: When the dealer's up card is an Ace. The player can make a side bid - which is half of the original bid - that the dealer's face down card will be a card with a value of 10. This will form a Combo for the dealer. This move can only be done at the start of the hand after the bid.
- The player can keep taking turns until the player is in one of the terminal states: Bust, Charlie, Combo, Value
  - **Bust**: The player's hand value is above '21'
  - **Charlie**: The player has at least 5 cards
  - **Combo**: The player has an Ace and a card worth ten (Ten, Jack, Queen, King)
  - **Value**: If the player stands, this is the final value of their hand
- The player's hand will be revealed (placed face up) when the player's turn ends

### Settling bids
- The dealer will only play if there are players who are not Bust
- If the dealer goes over '21', the dealer pays each player who decided to Stand double the amount of the player's bid
- If the player's hand has a higher value than the dealer's hand, the dealer will pay double the amount of the players bid
- If the player's hand has an equal value, the player will receive their initial bid back
- If the player has a Combo, the player will be paid back at 2.5 times (unless the dealer also has a Combo, in which the player receives their initial bid back)

The ordering for hand values is as follows:

1. Combo
2. Charlie
3. Value
4. Bust

### After Each Hand
- All cards played will be left face up on the table
- The dealer's hidden cards will only be shown if the dealer plays
- A new hand will be restarted

### Game Over
- The player will stop playing when Bankrupt (has 0 points)
- The game will keep going, while there is at least one player and while there is less than 1000 rounds.

### Final Standings

The final standings at the end of the game will be based on if the player had remaining points at the end of the game.
1. Players with points left
   - This will be sorted by the amount of points left by each player
   - Players with more points will have a higher standing
2. Players with no points left
   - This will be sorted by the order which the player ran out of points
   - Players who ran out of points earlier will have a lower standing

For example, consider a game with 5 players:

Player A - Ran out of points after game 10

Player B - Finished with 100 points

Player C - Ran out of points after game 100

Player D - Finished with 10 points

Player E - Ran out of points after game 5



The final standings will be as follows.
1. Player B
2. Player D
3. Player C
4. Player A
5. Player E


## Deliverable

For this assignment, you are required to implement a player exposing a single
function. This function is:

 1. `playFunc`, called when it is your turn to play a move. This includes bidding and playing each round.

A skeleton for the file can be found in `submission/Player.hs` in the
code bundle.

To keep the playing field level, and to allow us to evaluate your code, we ask
you to use only the libraries provided. In short, you cannot edit the `stack.yaml`
and `package.yaml` or add functionality to the source code (in `src/`).

You will need to submit a file called `studentNo_name.zip` which you will create
by zipping the contents of the `submission/` directory.

If you have any extensions, you will need to include them in a directory titled
`extensions/` in your zip file. If your extension requires additional libraries,
feel free to include your whole project -- except build files, e.g.
`.stack-work/` -- in the `extensions/` folder.

### Choosing an action

You will need to write a single function. This functions chooses your action.

This function will also be given information about the state of the game.
This information is:

- `Maybe Card` The dealers up-card. If this is `Nothing`, this represents the dealer has no cards. This can only happen on the bidding turn at the start of a round.
- `[PlayerPoints]` - The amount of points remaining for each player
- `[PlayerInfo]` - The most up to date information about all players (updating whenever a player plays their turn).
    - The order of players is randomised each game; therefore, you will need to keep track of the previous round's information to determine which information is new.
    - Note that the dealer's information is also included, but only updates after all other players have played.

    Four players: A, B, C, YOUR_PLAYER
    Your function will also receive information on each player, which we will show with id_{round}.
    Therefore, the info for A after round 1 will be A_1.

    Order in round 1: A, YOUR_PLAYER, B, C, dealer
    - Information Supplied: A_1

    Order in Round 2: A, YOUR_PLAYER, B, C, dealer
    - Information Supplied: A_2, YOUR_PLAYER_1, B_1, C_1, dealer_1

    Order in Round 3: A, YOUR_PLAYER, B, C, dealer
    - Information Supplied: A_3, YOUR_PLAYER_2, B_2, C_2, dealer_2

- `PlayerId` - The id of your player, to identify yourself in `PlayerInfo` and `PlayerPoints`
- `Maybe String` - Your memory string. On the first turn of the game, this will be Nothing.
- `[Card]` - Your current cards

``` haskell

data Action = Bid Points | Hit | Stand | DoubleDown Points | Split Points | Insurance Points

-- | Action function type.
type PlayFunc
    =  Maybe Card         -- Dealer's up-card
    -> [PlayerPoints]     -- Points for all players in game
    -> [PlayerInfo]       -- the most recent information for all players
    -> PlayerId           -- the player's id
    -> Maybe String       -- the player's memory
    -> Hand               -- the player's hand
    -> (Action, String)   -- the player's chosen action and new memory
```

### Managing the memory

An important component of the function above is the `String` which is your
player's *memory*. Your player needs to be able to keep track of some parameters
of the game through time. This is enabled by returning a `String` after
playing.

Internally, your player should use a custom datatype to store information rather
than a `String`. To enable conversion to and from your datatype, you will have
to use parser-combinators as presented in the course notes. The source code is
included in `src/Parser/`. **You will have to extend what we have given you, and use them in interesting ways to achieve the highest marks**.

Another thing that can be considered as *memory* is the score. At each of your
function calls, you will be given the score of the *last round* as: `(your
score, opponent score)`. This can help you adjust your strategy.


*Note*: Your memory cannot exceed 10,000 characters.

## Assessment

The assessment for this assignment will be in four parts:

 1. **Report (30%)**
 2. **Code quality (30%)**
 3. **Memory and parsing (20%)**
 4. **Player (20%)**

### Report

You are required to provide a report on your basic functionality in PDF format of two pages (penalties will be applied if you go over). Description of extensions can be included on additional pages (up to one page per extension). You should summarise the workings of the code, and highlight
the interesting parts and difficulties you encountered.

In particular, describing how your strategy, and thus your code, evolved will be
beneficial. You should focus on the **"why"**, **not** the **"how"**.

**Importantly**, this report must include a BNF grammar and a description about why and how parser combinator helped you complete the parsing.

In summary, it should include the following sections:
   - Design of the code (including data-structures)
   - Memory and Parsing (including [BNF grammar](https://tgdwyer.github.io/parsercombinators/#context-free-grammars-and-bnf))
   - Functional Programming and Haskell Language Features Used (focusing on the **why**)
   - Description of Extensions (if applicable)

### Code quality

The code quality will be the main evaluation criterion for your assignment.
You can think of this as a two-part marking scheme:

 1. Apply concepts from the course. The important thing here is that you need to
    actually use them somewhere. For example, defining a new type and its
    `Monad` instance, but then never actually needing to use it will not give
    you marks. (Note: using bind `(>>=)` for the sake of *using the `Monad`*
    when it is not needed will not count as "effective usage.")
 2. Have readable and **functional** code, commented when necessary. Readable code means that you
    keep your lines at a reasonable length (< 80 characters). That you provide
    comments above non-trivial functions. And, that you comment sections of your
    code whose function may not be clear.

#### Common Mistakes

  - Haskell is a functional language. Do not write very large do blocks which handle all of your logic. Think carefully about your context and only use do notation when applicable.
  - Please do not write things such as the following function. This is just a map.
``` haskell
applyToList f (x:xs) = f x : applyToList f xs
applyToList f [] = []
```
  - Try to use appropriate Prelude functions when you can. For examples of this, please see the 'Exercises' files that have been included since Week 6
  - Eta-reduce when easy. The add2List function should be eta-reduced to remove the l.
``` haskell
add2ToList l = map (+2) l
```
  - Use point-free form only where it simplifies and improves readability.  Do **not** write code like this (please):
``` haskell
find' = (. ((find .) . (.) . (==))) . (.) . (.) . maybe -1
```

Remember, the point of documentation is to give a *manual* rather than describe the
code. In the case of a function, you would explain how to use it rather than
what are the parameters, return types, etc.

The point of section/block comments are to describe blocks of code at a high level to aid in readability and support the overall logical flow of your code.

The point of inline comments are to justify the usage of particular constructs (e.g. using a `foldr` instead of `reduce`) or to explain how a particularly non-obvious part of the code works (e.g. describing what a complex maths expression does; note that excessive inline comments may indicate overly complex or poorly designed code).

### Memory and parsing

One of the key features of your player is the ability to keep track of the game.
To enable everyone to use their own datatypes, the game code will consider your
memory to be a `String`.

Handling complex data as strings is cumbersome. This means you will have to
implement *serialisation* and *deserialisation*. This will be done using a
*parser-combinator* -- of which you can see an explanation
[here](https://tgdwyer.github.io/parsercombinators/). The source code is
provided in `src/Parser/`.

You can use the `Show` instance to serialise your data structures. However, you
**must not** use (or derive) the `Read` instance. We require you to use the
parser-combinator supplied to handle deserialisation.

Your memory should help you make build a strategy across iterations. This means your player needs to use
the memory to compute relevant parameters for choosing an action. Simply storing
past information is not sufficient. For example, your player could use the
memory to compute statistics about unseen cards, your opponent's remaining points, etc.

### Player

We will run a tournament [online](https://fit2102.monash) based on the code
provided. Except the interface, this will be the same game.

**Important**: Your rank in the online tournament will not have a direct
impact on your mark. A high-performing player with spaghetti code will
be graded lower than an average, well-written player.

However, we will also upload a number of bots on the server. They will be
identifiable by having ids below 10. These bots can be used to get an indication of your player's performance.

You will also be marked on your player's performance against the bots in a **separate** tournament (not the online tournament).
Having a higher rank than them will award you marks:

 - *5%* for having a valid player, that is one which can play a game.
 - *5%* for having a continuing player, that is one which does not error
   during the tournament -- e.g., timeouts, breaking the game rules.
 - *5%* for beating at least one of the bots.
 - *5%* for beating all of the bots.

## Marking rubric

 - **Pass:** The code compiles without warnings and your player has some
   heuristic strategy (see Game AI below), you use some form of memory with
   parsing. The report supports the code.
 - **Credit:** You use the memory to store non-trivial information and have a
   clear report outlining your efforts.
 - **Distinction:** The code is well structured and uses some advanced concepts
   from the course -- higher order functions, function composition, monadic
   operations, etc.
 - **High Distinction:** The code does not contain any excess parts, functions are broken down appropriately,  the memory is used to store curated data about the game, the player can defeat all training opponents, and the documentation supports the submission.
 - **High Distinction +:** Extension that demonstrates advanced understanding of the unit material, code is easy to read and understand, leverages the type system.

Do note you can expect a higher mark with an average level AI with very neat
code, rather than a high-performing AI with spaghetti code.

### Game AI

The goal of this assignment is **not** for you to develop a sophisticated AI which can compete
with [OpenAI](https://openai.com/) or
[AlphaGo](https://deepmind.com/research/case-studies/alphago-the-story-so-far).
The emphasis should be on code quality and applying functional concepts.
A well implemented heuristic player that is excellent with respect to all the criteria
above is sufficient for an HD.

*Caveat:* A more complex player will give you more opportunities to show off what you know
and so to achieve the highest marks, it would be recommended to have a suitably complex player.

If you do want to try to develop a more sophisticated AI, below, is a non-exhaustive list of AI algorithms, ranked by
implementation difficulty, which you can use as reference.
Once again, a good heuristic is sufficient for an HD.
On the contrary, a complex Monte Carlo player
(see below) which has very bad code quality and makes no use of the memory may
very well not get a passing grade.

 - **Naïve AI:** tries to play its best card given the current state of the
   game, you can start by implementing one to make sure you respect the game's
   rules. However, this will not get a passing grade.
 - **Heuristic player:** has a procedure (heuristic) to determine the strength
   of its hand versus its opponent's and saves additional information about the
   game being played to enhance its decision at each turn.
 - **MinMax:**[^2] tries to minimise the maximum loss of a player by building a
   tree of possible moves and playing against itself. This method was developed
   for two-player, zero-sum game with perfect information. In this context, you
   will have to take into account the uncertain nature of the game.
 - **Probabilistic player:** will make use of probabilities to determine which
   cards have the highest chance of winning the game (i.e., appearing in the
   stock) or how good their opponent's hand is. It will make use of the memory
   to keep track of played cards and refine its calculations.

### Extensions

This assignment is fairly open-ended. You can achieve an HD with a solid player
and very neat code, but getting a high HD will require you to go beyond. Here,
you can find some ideas of what we consider extensions. All extensions need to
be supported by additional description in your report. Feel free to come
up with your own ideas for extensions but do check with tutors to see if they are worthwhile.

And don't forget, you will only be awarded marks for extension work that extends
an already high quality submission. If the core of your submission is not
already HD-worthy, the extension will not grant you many marks.

**Note:** The purpose of the extension is to demonstrate more advanced understanding of the unit content, consider carefully what part of the [assessment criteria](#assessment) you want to supplement with an extension.

#### Using logs to build a player

The game server (see below) will keep logs of your games against other players.
Reports for each game will come in two files named:

1. `<timestamp>.csv` the logs of the turns taken by each player, anonymised.
2. `<timestamp>-score.csv` the score for each round of the game, along with the
   action taken.

You can write a Haskell program to data-mine these reports and tailor some parts
of your player accordingly.

**Note:** The specifications for the logs may change due to student requests,
we will provide updates as required.

##### Turn file

``` csv
1,SQ;H3;D6,0,0,0,Stand,10,DK
```

Each file will be the record of *one game* -- so, multiple rounds. The file will
come without a header but here are the columns:

1. Round number.
2. Cards in the player's hand -- the format is `<first char of suit><rank>`
   separated by ';'. *Note:* these are the cards *at the end of the turn,* so
   they include the drawn card -- as opposed to what your function receives.
3. The id of the player.
4. Whether it is *your turn* to play -- '0' means your opponent's turn and '1'
   your turn.
5. The second id of the hand. This is normally 0, unless you have split. If you have split it will goto 1.
6. The Action which the player took
7. The current bid amount of the player
8. And, the upcard of the dealer.

##### Score file

``` csv
16,10015,9960;9920;9985;9950;10055;10240;10120;9975;9960;10005
```

Each file will record one round per row, formatted as:

1. Round number.
2. Your score.
3. Opponent's score sorted by their playerId, seperated by ';'


#### Monte Carlo Tree Search

Monte Carlo Tree Search (MCTS) is the fusion between (tree) search algorithms
such as minmax and using probabilities (Monte Carlo simulation) to determine the
branching in the search tree. It makes use of a *simulation phase* to explore
deeper. In this context, you can leverage the memory to save already explored
branches, or weight, etc.

*Hint:* Building a MCTS player requires having access to a source of entropy for
side-effect-free random number generation; you can use your hand as it comes
from a shuffled deck.

#### Writing an extensive test suite

Testing in functional languages is often done semi-automatically. This is
because the test framework can leverage the type system to generate arbitrary
inputs -- think fuzzing.

In the course material, we use [Doctest](https://github.com/sol/doctest#readme).
You may have seen lines starting with `prop>`. These mean "properties" and what
is great, for us programmers, is that we do not need to come up with inputs, the
testing framework does it itself.

The leading test framework in Haskell is
[QuickCheck](https://hackage.haskell.org/package/QuickCheck). It is actually
what is called in the `prop>` example above. Identifying properties (sometimes
called invariants) of your code can help you write better functions.

This is normally the **hardest** extension to do well - the test suite must be *extensive*. By that we
mean that your tests need to show the correctness of your functions (not just
"returns a `Card`"). Furthermore, you will need a compelling report showing how
you used the test suite to design your code -- think Test Driven Development,
where you determine the function's behaviour first rather than writing it and
adding tests for cases you think of.

### Plagiarism

<https://www.monash.edu/students/admin/policies/academic-integrity>

We will be checking your code against the rest of the class, and the
internet, using a plagiarism checker. Monash applies strict penalties
to students who are found to have committed plagiarism.

Any plagiarism will lead to a 0 mark for the assignment and will be
investigated by the staff.  There is a zero-tolerance policy in place at
Monash.  So be careful and report any collaboration with other students.

Also, it is your responsibility to keep your code private. If you use an online repository like GitHub you **must ensure** that it is not public.

## Tournament server

We will run a server for the course at <https://www.fit2102.monash> with the
following pages:

 - [The uploader](https://www.fit2102.monash/uploader/): after logging in,
   this page will allow you to upload your code and compete in the
   tournament.
 - [The handout](https://www.fit2102.monash/resources/assignment.html):
   this document.
 - [The ladder](https://www.fit2102.monash/ladder.php): this
   page will display the scores of the last tournament run.

One thing to note is that the server only accept submissions as whole files. If
your code uses a multi-file structure, you will need to concatenate them into
your `Player.hs` before uploading.

Once you upload your player, you will see two links on the page:

 - `home.php`: shows your current ranking, last upload, and previous
   games played.
 - `status.php`: shows the status of your current upload. Furthermore, you can
   inspect your games by clicking on their number.

Before uploading your player, please check that the following runs:

```
stack exec staticgame
```

This will run a single game with two instances of your player. You can modify
this code (found in `staticgame/Main.hs`) to run different versions of your
code.

You cannot import external libraries because the server cannot know about them.
In a nutshell, you cannot edit the `stack.yaml` or the `package.yaml`.

The code provided uses the Safe pragma[^1] to make sure the code you use is okay
to run. It is also compiled with the `-Werror` flag which means that all
warnings will throw errors and prevent your code from compiling. So make sure
you run the test suite before you upload your player.

## Debugging your Code

Students often ask how to debug their haskell code.  A common strategy is to use [`Debug.Trace`](https://hackage.haskell.org/package/base-4.15.0.0/docs/Debug-Trace.html).
You are welcome to use this in your development.  However, please be careful to comment out any `Trace` code before you submit to the server.

### Summary of tournament submission rules

 - *Respect the rules:* your player must always play valid actions or it will be
   eliminated.
 - *Be timely:* to give everyone a fair chance, your function must return
   in under one second.
 - *Be safe:* your player must compile with all flags provided, including the
   `import safe`.
 - *Single file:* your code must be submitted on the server as a single file.

[^1]: More info at
    [SafeHaskell](https://ghc.haskell.org/trac/ghc/wiki/SafeHaskell), but this
    should not hinder your work.

[^2]: https://en.wikipedia.org/wiki/Minimax
