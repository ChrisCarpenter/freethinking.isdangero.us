module ActiveRecord
  module Acts #:nodoc:
    module Taggable #:nodoc:
      module SingletonMethods

        def find_tagged_with(list,*args)
          #build the limit sql
          options = args.last.is_a?(Hash) ? args.pop.symbolize_keys : {}
          limit,offset = options.delete(:limit), options.delete(:offset) unless options.empty?
          scope =  (limit && offset) ? "LIMIT #{offset}, #{limit}" : "" 

          find_by_sql([
            "SELECT #{table_name}.* FROM #{table_name}, tags, taggings " +
            "WHERE #{table_name}.#{primary_key} = taggings.taggable_id " +
            "AND taggings.taggable_type = ? " +
            "AND taggings.tag_id = tags.id AND tags.name IN (?) #{scope}",
            acts_as_taggable_options[:taggable_type], list
          ])

        end
        #will_paginate will call find_all_tagged_with
        alias find_all_tagged_with find_tagged_with
      end     
    end
  end
end