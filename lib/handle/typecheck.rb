

# This file is part of Yoink.

# Copyright 2019, Violet Baddley.
# All Rights Reserved.

# This software is provided under the terms of the Chillbot Social License, version
# 0.1.0. The full text of the license is distributed along with this file.



class Plugins
  def self.typecheck args, types

    raise "missing 'with' key in the manifest" unless args
    raise "the 'with' block is not a Hash" unless args.is_a? Hash

    types.each do |arg, type|
      arg = arg.to_s  # To accommodate symbols
      raise "argument '#{arg}' expected but not given" unless args[arg]
      raise "arugment '#{arg}' is not a #{type}" unless args[arg].is_a? type
    end

  end
end
