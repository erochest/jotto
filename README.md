# Description

This will be a [Jotto game](http://en.wikipedia.org/wiki/Jotto) for one player.
See the Wikipedia article for details on the rules.

A typical interaction might look like this:

    I'm thinking of a five-letter word. Guess what it is.
    Guess 1 of 10: think
    1 jot.
    Guess 2 of 10: burnt
    2 jots.
    Guess 3 of 10: xyzzy
    Nothing. Try again.
    ....
    You're out of turns! Better luck next time.
    (or)
    That's it! Great guessing.

# How to Hack

On the command-line (assuming you have [rvm][rvm] installed):

    $ rvm gemset create jotto
    $ source .rvmrc
    $ bundle

(If this gives an error, you may need to run `gem install bundle` first.)

Now, if you will be working on `lib/document.rb`, you can run the tests like
this:

    $ rspec spec/document_spec.rb

Pick one of the failing tests, figure out why it's failing, and fix it.

Lather. Rinse. Repeat.

# Some Useful Resources

* [Ruby Docs][rubydocs]
* [RSpec][rspec]

[rvm]: https://rvm.io/ 
[rubydocs]: http://www.ruby-doc.org/
[rspec]: http://rspec.info/
