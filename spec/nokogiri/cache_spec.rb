require 'spec_helper'
require 'action_controller'

def controller
  ActionController::Base.new
end
public :controller

XML_FRAGMENT = <<-XML
<countries>
  <country name="Canada">
    <languages>
      <language>English</language>
      <language>French</language>
    </languages>
  </country>
  <country name="United States">
    <abbreviation>USA</abbreviation>
  </country>
</countries>
XML

def build_xml(builder)
  builder.instance_eval do |xml|
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

describe Nokogiri::Cache do
  let(:builder) { Nokogiri::XML::Builder.new }
  let(:xml_out) { %|<?xml version="1.0"?>\n#{XML_FRAGMENT}| }

  it 'should return the proper XML when the fragment is not in the cache' do
    allow(builder).to receive(:read_fragment).with('countries', anything).and_return(nil)
    build_xml(builder)
    expect(builder.to_xml).to eq(xml_out)
  end

  it 'should return the proper XML when the fragment is in the cache' do
    allow(builder).to receive(:read_fragment).with('countries', anything).and_return(XML_FRAGMENT)
    build_xml(builder)
    expect(builder.to_xml).to eq(xml_out)
  end

  it 'should return the proper XML when caching is disabled' do
    ActionController::Base.perform_caching = false
    build_xml(builder)
    expect(builder.to_xml).to eq(xml_out)
  end
end
