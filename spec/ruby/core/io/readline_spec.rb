# -*- encoding: utf-8 -*-
require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "IO#readline" do
  before :each do
    @io = IOSpecs.io_fixture "lines.txt"
  end

  after :each do
    @io.close unless @io.closed?
  end

  it "returns the next line on the stream" do
    @io.readline.should == "Voici la ligne une.\n"
    @io.readline.should == "Qui è la linea due.\n"
  end

  it "goes back to first position after a rewind" do
    @io.readline.should == "Voici la ligne une.\n"
    @io.rewind
    @io.readline.should == "Voici la ligne une.\n"
  end

  it "returns characters after the position set by #seek" do
    @io.seek(1)
    @io.readline.should == "oici la ligne une.\n"
  end

  it "raises EOFError on end of stream" do
    IOSpecs.lines.length.times { @io.readline }
    -> { @io.readline }.should raise_error(EOFError)
  end

  it "raises IOError on closed stream" do
    -> { IOSpecs.closed_io.readline }.should raise_error(IOError)
  end

  it "assigns the returned line to $_" do
    IOSpecs.lines.each do |line|
      @io.readline
      $_.should == line
    end
  end

  describe "when passed chomp" do
    it "returns the first line without a trailing newline character" do
      @io.readline(chomp: true).should == IOSpecs.lines_without_newline_characters[0]
    end
  end
end
