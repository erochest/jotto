
require 'jotto/console'

module Jotto
  def self.add_fail(console)
    console.jotto.stub(:guess).and_return(
      {:guess => 1, :won => false, :over => false, :jots => 1 },
      {:guess => 2, :won => false, :over => false, :jots => 2 },
      {:guess => 3, :won => false, :over => true,  :jots => 3 }
    )
  end

  def self.add_success(console)
    console.jotto.stub(:guess).and_return(
      {:guess => 1, :won => false, :over => false, :jots => 1 },
      {:guess => 2, :won => true,  :over => true,  :jots => 2 }
    )
  end

  def self.accum_stdout
    buffer = []
    STDOUT.should_receive(:puts).at_least(:once) do |*args|
      buffer << args.join(" ")
    end
    return buffer
  end

  describe Console do
    subject do
      secret = double('secret')
      secret.stub(:length => 5)

      jotto = double('jotto')
      jotto.stub(:secret => secret)
      jotto.stub(:guess_count).and_return(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
      jotto.stub(:max_guess_count => 3)
      jotto.stub(:new_game)

      Console.new jotto
    end

    describe '#game' do
      it 'should be stoppable by entering "Q!"' do
        buffer = []
        n = 0

        STDIN.stub(:gets).and_return("Q!")
        STDOUT.should_receive(:puts).exactly(3).times do |*args|
          n += 1
          buffer << args.join(' ')
        end
        subject.game

        buffer.length.should eq(3)
        buffer[2].should =~ /bye/i
      end

      it 'should call Jotto#new_game before each game.' do
        STDIN.stub(:gets).and_return("Q!")
        STDOUT.stub(:puts)
        subject.jotto.should_receive(:new_game).once
        subject.game
      end

      it 'should tell the user how many letters are in the secret word.' do
        buffer = Jotto::accum_stdout
        STDIN.stub(:gets).and_return("Q!")
        subject.game
        buffer.join("\n").should =~ /5-letter/
      end

      it 'should list the number of the guess.' do
        buffer = Jotto::accum_stdout
        STDIN.stub(:gets).and_return("Q!")
        subject.game
        buffer.join("\n").should =~ /Guess #?\s*1/
      end

      it 'should show the possible number of guesses.' do
        buffer = Jotto::accum_stdout
        STDIN.stub(:gets).and_return("Q!")
        subject.game
        buffer.join("\n").should =~ /of 3/
      end

      it 'should should quit if the player has not guess the right word soon enough.' do
        Jotto::add_fail subject
        buffer = Jotto::accum_stdout
        STDIN.stub(:gets).and_return("aaaaa\n", "bbbbb\n", "ccccc\n")
        subject.game
        buffer[-1].should =~ /lost/i
      end

      it 'should stop when the player guesses the right word.' do
        Jotto::add_success subject
        buffer = Jotto::accum_stdout
        STDIN.stub(:gets).and_return("aaaaa\n", "bbbbb\n")
        subject.game
        buffer[-1].should =~ /won/i
      end

      it 'should display the number of matching letters in the guess.' do
        Jotto::add_fail subject
        buffer = Jotto::accum_stdout
        STDIN.stub(:gets).and_return("aaaaa\n", "bbbbb\n", "ccccc\n", "Q!\n")

        subject.game

        output = buffer.join("\n")
        output.should =~ /1 jot/
        output.should =~ /2 jots/
        output.should =~ /3 jots/
      end
    end

  end
end
