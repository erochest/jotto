
require 'spec_helper'

module Jotto
  describe Dictionary do

    it "should create a dictionary with no words." do
      subject.length.should eq 0
    end

    describe '#load_file' do
      it "should load a file and populate the dictionary." do
        expected = `wc -l data/words`.split[0].to_i
        subject.load_file("data/words").length.should eq expected
      end
    end

    describe '#filter_length' do
      it "should filter out words that that aren't a given length." do
        subject.words << 'a' << 'aa' << 'aaa' << 'aaaa' << 'aaaaa' << 'aaaaaa'
        subject.filter_length 5
        subject.length.should eq 1
        subject.words.to_a.should eq ['aaaaa']
      end
    end

    describe '#filter_duplicate_letters' do
      it 'should remove all words that have duplicate letters.' do
        subject.words << 'a' << 'aa' << 'ab' << 'bb' << 'cc' << 'abc'
        subject.filter_duplicate_letters
        subject.length.should eq 3
        subject.length.to_a.sort.should eq ['a', 'ab', 'abc']
      end
    end

    describe '#random-word' do
      it 'should return a random word from the dictionary.' do
        subject.words << 'a' << 'b' << 'c' << 'd' << 'e'
        word = subject.random_words
        subject.words.count(word).should eq 1
      end
    end

  end

end
