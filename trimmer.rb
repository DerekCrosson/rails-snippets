module Trimmer
  # Make a class method available to define space-trimming behavior.
  def self.included base
    base.extend(ClassMethods)
  end
 
  module ClassMethods
    # Register a before-validation handler for the given fields to trim leading and trailing spaces.
    def trimmed_fields *field_list
      before_validation do |model|
        field_list.each do |n|
          model[n] = model[n].strip if model[n].respond_to?('strip')
        end
      end
    end
  end
end

# Usage Example
# Put the module above in lib/trimmer.rb
# In the model where you want to strip whitespace, call the module like this before declaring the class: require 'trimmer'
# Add an array of fields that you want to trin to trimmed_fields
# The function will be run before saving the fields to the database

# Example below:
# require 'trimmer'
# class User < ApplicationRecord
# include Trimmer # Include the module after declaring the class
# trimmed_fields [:firstname, :lastname]
