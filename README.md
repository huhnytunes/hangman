hangman
=======

Phase 1 AGILE Hangman

1. What it is
This is a Hangman terminal application which allows the user to play either against the computer (ie. a random word is picked for them) or against another player (they choose a word for their partner to guess).
The player guesses letters which he / she thinks to be in the word, and then the app returns whether this is true or not.
For correct guesses, the letter is added to the corresponding blank space in the word guess. And for incorrect guesses, the letter is added to the guess bank and a part of the visual hangman is removed.
The player wins when they guess all the letters correctly in the word, but is lost if they cannot do so before the hangman is 'taken' apart.

2. How it works
By implementing the MVC model, we can adequetely mimick a visual Hangman round in the terminal. The model pulls words from a dictionary file and parses through it in order to either choose a random word, or a word of a given length. The controller is used to access these words and pass them over to the viewer where they are visualized along with the Hangman game template. By bridging these three disparate parts, the program is able to mirror a game of Hangman, done entirely on a computer!

3. How to use it
Simply follow the on-screen instructions in order to play a game of hangman. The user can choose whether they wish to play against a computer with a random word, a word of certain length, or choose a word so that another player can try and guess it. All in all, a rather straight-forward yet surprisingly fun application!
