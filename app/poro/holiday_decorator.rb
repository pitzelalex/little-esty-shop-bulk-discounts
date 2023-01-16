class HolidayDecorator
  def initialize(code)
    @holidays = HolidayService.new(code).parsed
  end

  def next_holidays(num)
    names = @holidays.first(num).map.with_index do |holiday, index|
      holiday[:name]
    end
  end
end
