

# This file is part of Yoink.

# Copyright 2019, Violet Baddley.
# All Rights Reserved.

# This software is provided under the terms of the Chillbot Social License, version
# 0.1.0. The full text of the license is distributed along with this file.



module YAML
  def self.load_from_io io

    # Coercing each line here to utf-8
    cumulative = String.new(capacity: 4096, encoding: "utf-8")

    begin
      loop do
        line = io.readline
        cumulative << line

        break if line =~ /^\.\.\.$/

      end
    rescue EOFError => e
      # Reached end of stream. In this context this probably means an
      # error, but for maximum correctness we should just try and load
      # what we have so far.
    end

    safe_load cumulative

  end
end
