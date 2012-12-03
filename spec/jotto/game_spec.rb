
require 'jotto'
module Jotto
  describe Game do
    subject do
      dict = double('dictionary')
      dict.stub(:random_word).and_return('zzzzz', 'yyyyy')

      secret = double('secret')
      secret.stub(:is_word?).and_return(false, false, true)
      secret.stub(:word => 'abcde')
      secret.stub(:get_matches).and_return(4, 3, 2)

      Game.new(10, dict, secret)
    end

    it "should initialize to no guesses." do
      subject.guess_count.should eq(0)
    end

    it "should track the maximum number of guesses." do
      subject.max_guess_count.should eq(10)
    end

    describe '#new_game' do
      it "should reset the guess count." do
        subject.guess 'something'
        subject.guess_count.should eq(1)

        subject.new_game
        subject.guess_count.should eq(0)
      end

      it "should select a new word." do
        subject.new_game
        subject.secret.should_receive(:word=).with('zzzzz')
      end
    end

    describe '#guess' do
      it "should return a hash with the keys :guess, :won, :over, :matches." do
        guess = subject.guess('aaaaa')
        guess.keys.sort.should eq([:guess, :matches, :over, :won])
      end

      it "should return the guess count." do
        subject.guess('aaaaa')[:guess].should eq(1)
        subject.guess('bbbbb')[:guess].should eq(2)
      end

      it "should return whether the game is over." do
        subject.guess('aaaaa').has_key?(:over).should eq(true)
      end

      it "should return whether the game is won." do
        subject.guess('aaaaaa').has_key?(:won).should eq(true)
      end

      it "should return the correct number of jots in the guess." do
        subject.guess('abcdd')[:jots].should eq(4)
        subject.guess('abccc')[:jots].should eq(3)
        subject.guess('abbbb')[:jots].should eq(2)
      end

      it "should increment the number of guesses." do
        subject.guess('aaaaa')[:guess].should eq(1)
        subject.guess('abbbb')[:guess].should eq(2)
        subject.guess('abccc')[:guess].should eq(3)
      end

      it "should indicate that the game is over and won when given the secret." do
        subject.guess('aaaaa')[:won].should eq(false)
        subject.guess('abbbb')[:won].should eq(false)
        subject.guess('abccc')[:won].should eq(true)
      end

      it "should indicate that the game is over and lost when all turns are over." do
        secret = double('secret')
        secret.stub(:is_word?).and_return(false)
        secret.stub(:word => 'abcde')
        secret.stub(:get_matches).and_return(4, 3, 2, 0)
        jotto = Game.new(5, subject.dict, secret)

        jotto.guess('aaaaa')[:over].should eq(false)
        jotto.guess('bbbbb')[:over].should eq(false)
        jotto.guess('ccccc')[:over].should eq(false)
        jotto.guess('ddddd')[:over].should eq(false)

        over = jotto.guess('eeeee')
        over[:over].should eq(true)
        over[:won ].should eq(false)
      end
    end
  end
end
