require "nokogiri/cache/version"
require 'nokogiri'

module Nokogiri
  module Cache
    # Allow nokogiri templates to do fragment caching
    # We can't just use Rails' built in cache helper because the document is not built as we go along so
    # the output buffer has no data
    # Instead, we can override caching to be able to put XML fragments into the cache and pull them out
    # to be inserted into a document later
    # NOTE: This code mostly mirrors action_view/helpers/cache_helper.rb
    def cache(name, options = nil, &block)
      @context = eval('self', block.binding)
      controller = @context.controller

      if controller.perform_caching
        get_fragment(controller, name, options, &block)
      else
        yield self
      end
    end

  private

    def get_fragment(controller, name, options, &block)
      if fragment = read_fragment(name, options)
        self << fragment.strip
      else
        # Create an XML fragment to insert the cached XML into
        # A root node is needed in case there are multiple nodes being inserted at the same level
        fragment = Nokogiri::XML::Builder.new { |xml| xml.root }
        Nokogiri::XML::Builder.with(fragment.doc.children.first, &block)

        # Grab the XML within the root node and render it to a string (we don't want to include the root node as it was
        # just added for processing)
        xml = fragment.doc.root.children.to_xml(encoding: 'UTF-8', save_with: Nokogiri::XML::Node::SaveOptions::NO_DECLARATION)

        # Save the fragment XML to the cache
        write_fragment(name, xml, options)
        self << xml.strip
      end
    end

    def read_fragment(key, options)
      controller.read_fragment(key, options)

    rescue Redis::CannotConnectError, Redis::ConnectionError, Redis::TimeoutError => e
      handle_cache_error(e)
      nil
    end

    def write_fragment(key, value, options)
      controller.write_fragment(key, value, options)

    rescue Redis::CannotConnectError, Redis::ConnectionError, Redis::TimeoutError => e
      handle_cache_error(e)
      nil
    end

    def handle_cache_error(e)
      Rails.logger.error 'Cache is not available'
    end
  end
end

Nokogiri::XML::Builder.send(:include, Nokogiri::Cache)
