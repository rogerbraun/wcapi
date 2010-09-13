# Tests for wcapi

require "test/unit"
require "wcapi"

# In development,
# I always run everything from the lib/ directory.

class WCAPI_test < Test::Unit::TestCase

  def setup
    @client = WCAPI::Client.new :wskey => ''
  end

  def test_open_search
    response = @client.open_search(:q=>'building digital libraries', :format=>'atom', :start => '1', :count => '25', :cformat => 'all')

    assert_equal 2724, response.header["totalResults"].to_i

    rec = response.records.first
    assert_equal "Building digital libraries : a how-to-do-it manual", rec[:title]
    assert_equal "http://worldcat.org/oclc/145732819", rec[:link]
    assert_kind_of Array, rec[:author]
    assert_equal "Reese, Terry.", rec[:author].first
    assert_equal "145732819", rec[:id]
    assert_equal "", rec[:summary]
    assert !rec[:citation].empty?
  end

  def test_get_record
    record = @client.get_record(:type => "oclc", :id => "15550774")

    assert_equal "Battle cry of freedom :", record.record[:title]
    assert_equal "http://www.worldcat.org/oclc/15550774", record.record[:link]
  end

  def test_get_locations
    info = @client.get_locations(:type=>"oclc", :id => "15550774")

    ins = info.institutions.first
    assert_equal 10, info.institutions.size
    assert_equal "ATVCM", ins[:institution_identifier]
    assert_equal "http://www.worldcat.org/wcpa/oclc/15550774?page=frame&url=http%3A%2F%2Fwww.melbournelibraryservice.com.au%26checksum%3D9bdbd26fa4bff7aa0cd0831ff44c7e34&title=Melbourne+Library+Service&linktype=opac&detail=ATVCM%3AMelbourne+Library+Service%3APublic Library&app=wcapi&id=ORE-Oregon+State", ins[:link]
    assert_equal 1, ins[:copies].to_i
  end

  def test_citation
    citation = @client.get_citation(:type=>"oclc", :id=>"15550774", :cformat => 'all')
    assert_equal 966, citation.size
  end

  def test_sru_example
    records = @client.sru_search(:query => "civil war")
    assert_equal 0, records.header["numberOfRecords"].to_i
    #assert_equal "", records.first[:title]
    #assert_equal "", records.first[:link]
  end
end
