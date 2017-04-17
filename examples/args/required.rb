$:.unshift 'lib'
require 'cl'

class Required < Cl::Cmd
  register :required

  arg :one, required: true
  arg :two

  def run
    [self.registry_key, one: one, two: two]
  end
end

def output(cmd, args)
  args = args.map { |key, value| "#{key}=#{value.inspect}" }.join(' ')
  puts "Called #{cmd} with #{args}"
end

output *Cl.run(*%w(required one two))
# Output:
# Called required with one="one" two="two"

output *Cl.run(*%w(required one))
# Output:
# Called required with one="one" two=nil

output *Cl.run(*%w(required))
# Output:
# Missing arguments (given: 0, required: 1)
#
# Usage: args.rb required one [two]

output *Cl.run(*%w(required one two three))
# Output:
# Too many arguments (given: 3, allowed: 2)
#
# Usage: args.rb required one [two]
