#
# Copyright (C) 2012 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

require 'pqueue'

module KWayMerge
  def self.combine(subcollections, &sort_indexer)
    stream = KWayMerge::Stream.new(subcollections, &sort_indexer)
    results = []
    results << stream.shift until stream.empty?
    results
  end

  class Stream
    def initialize(subcollections, &sort_indexer)
      @subcollections, @sort_indexer = subcollections, sort_indexer

      # lowest sort key value has highest priority, so b first
      @queue = PQueue.new { |a,b| b.sort_value <=> a.sort_value }
      @subcollections.size.times{ |index| add_from_index(index) }
    end

    def empty?
      @queue.empty?
    end

    def shift
      if empty?
        nil
      else
        entry = @queue.pop
        add_from_index(entry.index)
        entry.element
      end
    end

    def iterate(count=:all)
      raise ArgumentError unless count == :all || count.is_a?(Fixnum)
      count = nil if count == :all
      until empty? || (count && count <= 0)
        yield shift
        count -= 1 if count
      end
      self
    end

    def skip(count=1)
      iterate(count) {}
    end

    def collect(count=:all)
      results = []
      iterate(count) { |item| results << item }
      results
    end

    private

    class Entry < Struct.new(:element, :index, :sort_index)
      def sort_value
        [sort_index, index]
      end
    end

    def add_from_index(index)
      subcollection = @subcollections[index]
      unless subcollection.empty?
        element = subcollection.shift
        @queue << Entry.new(element, index, @sort_indexer[element])
      end
    end
  end
end
