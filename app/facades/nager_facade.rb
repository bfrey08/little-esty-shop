class NagerFacade
  def self.create_holidays
    Rails.cache.fetch('holidays', :expires => 1.hour) do
      json = NagerService.holidays
      json.map do |data|
        Holidays.new(data)
      end
    end
  end

end
