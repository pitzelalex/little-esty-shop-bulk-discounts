class HolidayDecorator
  def initialize(code)
    @holidays = HolidayService.new(code).parsed
  end

  def next_holidays(num)
    @holidays.map.with_index do |holiday, index|
      break if index == num
      holiday[:name]
    end
  end
end
