#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
# usage: export filepath=/path/to/file; ruby <this file>
path = ENV['filepath'];
text = File.read(path);
text.gsub!(/^#?/,"");
print text;
