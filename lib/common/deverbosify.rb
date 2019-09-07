

# This file is part of Yoink.

# Copyright 2019, Violet Baddley.
# All Rights Reserved.

# This software is provided under the terms of the Chillbot Social License, version
# 0.1.0. The full text of the license is distributed along with this file.



# This wraps a block of code, and catches all standard errors. If any arise, it checks to
# see whether a '--verbose' flag was passed in the command arguments, and prints out an
# abbreviated version (without the backtrace) otherwise.
#
# It is only to be used in the main file, as it will exit with a nonzero code on anything
# it rescues.



module Common
  def self.deverbosify

    yield

  rescue => e
    if ARGV.include? "--verbose"
      $stderr.puts e.full_message

    else
      $stderr.puts e.inspect
      $stderr.puts "To see a full backtrace, re-run with the '--verbose' flag."
    end

    exit -1
  end
end
