require 'jotto'

require 'stringio'

module SpecUtils
  def SpecUtils.capture_output(input, &block)
    original_stdout = $stdout
    original_stdin  = $stdin

    $stdout = fake = StringIO.new
    $stdin  = StringIO.new input
    begin
      result = yield
    ensure
      $stdout = original_stdout
      $stdin  = original_stdin
    end

    {:result => result, :output => fake.string}
  end
end
