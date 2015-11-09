# -*- encoding : utf-8 -*-
require 'rubygems'
require 'rspec'

require 'pp'

%w(
  gaussian_distribution
  truncated_gaussian_correction_functions
).each do |name|
  require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "numerics", "#{name}.rb"))
end

def tolerance
  0.001
end