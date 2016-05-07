$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'benchmark/ips'
require 'action_controller'
require 'nokogiri/cache'

def controller
  ActionController::Base.new
end
public :controller

Benchmark.ips do |x|
  x.report('uncached') do
    Nokogiri::XML::Builder.new do |xml|
      xml.countries do
        xml.country(name: 'Canada') do
          xml.languages do
            xml.language 'English'
            xml.language 'French'
          end
        end

        xml.country(name: 'United States') do
          xml.abbreviation 'USA'
        end
      end
    end
  end

  x.report('cached') do
    ActionController::Base.perform_caching = true

    Nokogiri::XML::Builder.new do |xml|
      xml.cache 'countries' do |xml|
        xml.countries do
          xml.country(name: 'Canada') do
            xml.languages do
              xml.language 'English'
              xml.language 'French'
            end
          end

          xml.country(name: 'United States') do
            xml.abbreviation 'USA'
          end
        end
      end
    end
  end

  x.report('Rails.cache disabled') do
    ActionController::Base.perform_caching = false

    Nokogiri::XML::Builder.new do |xml|
      xml.cache 'countries' do |xml|
        xml.countries do
          xml.country(name: 'Canada') do
            xml.languages do
              xml.language 'English'
              xml.language 'French'
            end
          end

          xml.country(name: 'United States') do
            xml.abbreviation 'USA'
          end
        end
      end
    end
  end

  x.compare!
end
