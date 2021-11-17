class NagerService


  def self.holidays
    response = get_url('https://date.nager.at/api/v1/Get/').get('us/2021')
    JSON.parse(response.body, symbolize_names: true)
  end



  def self.get_url(url)
    Faraday.new(url)
  end
end
