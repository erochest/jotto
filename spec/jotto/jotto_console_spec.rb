
require 'spec_helper'
#require '../utils'

module Jotto
  def add_fail(console)
    console.jotto.stub(:guess).add_return(
      {:guess => 1, :won => false, :over => false, :jots => 1 },
      {:guess => 2, :won => false, :over => false, :jots => 2 },
      {:guess => 3, :won => false, :over => true,  :jots => 3 }
    )
  end

  def add_success(console)
    console.jotto.stub(:guess).add_return(
      {:guess => 1, :won => false, :over => false, :jots => 1 },
      {:guess => 2, :won => true,  :over => true,  :jots => 2 }
    )
  end

  describe JottoConsole do
    subject do
      secret = double('secret')
      secret.stub(:length => 5)

      jotto = double('jotto')
      jotto.stub(:secret => secret)
      jotto.stub(:guess_count => 0)
      jotto.stub(:max_guess_count => 3)

      JottoConsole.new jotto
    end

    describe '#game' do
      it 'should be stoppable by entering "Q!"' do
        output = SpecUtils.capture_output "Q!\n" do
          subject.game
        end
        # One for the introduction, one for the prompt, and one for saying bye.
        output[:output].lines.count.should eq 3
      end

      it 'should call Jotto#new_game before each game.' do
        output = SpecUtils.capture_output "Q!\n" do
          subject.game
        end
        subject.jotto.should_receive(:new_game).once
      end

      it 'should tell the user how many letters are in the secret word.' do
        output = SpecUtils.capture_output "Q!\n" do
          subject.game
        end
        output[:output].should =~ /5-letter/
      end

      it 'should list the number of the guess.' do
        output = SpecUtils.capture_output "Q!\n" do
          subject.game
        end
        output[:output].should =~ /Guess #?\s*1/
      end

      it 'should show the possible number of guesses.' do
        output = SpecUtils.capture_output "Q!\n" do
          subject.game
        end
        output[:output].should =~ /of 3/
      end

      it 'should increment the guess number after each guess.' do
        add_fail subject
        output = SpecUtils.capture_output "aaaaa\nQ!\n" do
          subject.game
        end
        output[:output].should =~ /Guess #?\s1/
        output[:output].should =~ /Guess #?\s2/
      end

      it 'should display the number of matching letters in the guess.' do
        add_fail subject
        input = "aaaaa\nbbbbb\ncccccc\n"
        output = SpecUtils.capture_output input do
          subject.game
        end
        output[:output].should =~ /1 jot/
        output[:output].should =~ /2 jots/
        output[:output].should =~ /3 jots/
      end

      it 'should should quit if the player has not guess the right word soon enough.' do
        add_fail subject
        input = "aaaaa\nbbbbb\nccccc\n"
        output = SpecUtils.capture_output input do
          subject.game
        end
        output[:output].lines.to_a[-1].should =~ /lost/i
      end

      it 'should stop when the player guesses the right word.' do
        add_success subject
        input = "aaaaa\nbbbbb\n"
        output = SpecUtils.capture_output input do
          subject.game
        end
        output[:output].lines.to_a[-1].should =~ /won/i
      end
    end

  end
end
