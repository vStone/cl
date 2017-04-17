require 'cl/cmd'
require 'cl/help'
require 'cl/runner/default'
require 'cl/runner/multi'

module Cl
  class Error < StandardError
    MSGS = {
      missing_args:  'Missing arguments (given: %s, required: %s)',
      too_many_args: 'Too many arguments (given: %s, allowed: %s)',
      wrong_type:    'Wrong argument type (given: %s, expected: %s)'
    }

    def initialize(msg, *args)
      super(MSGS[msg] ? MSGS[msg] % args : msg)
    end
  end

  ArgumentError = Class.new(Error)

  def included(const)
    const.send(:include, Cmd)
  end

  def run(*args)
    runner(*args).run
  rescue Error => e
    abort [e.message, runner(:help, *args).cmd.help].join("\n\n")
  end

  def help(*args)
    runner(:help, *args).run
  end

  attr_writer :runner
  @runner = :default

  def runner(*args)
    args = args.flatten
    runner = args.first.to_s == 'help' ? :default : @runner
    Runner.const_get(runner.to_s.capitalize).new(*args)
  end

  extend self
end
