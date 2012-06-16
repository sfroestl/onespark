module DateHelper
  
  def date_format(date)
    date.to_datetime.strftime('%d.%m.%Y - %H:%M:%S')
  end
  
  def format_date(date)
    date.to_datetime.strftime('%d.%m.%Y - %H:%M:%S')
  end
  
  def due_date_not_in_past_but_can_be_empty
    if self.due_date.nil?
      true
    elsif  self.due_date < DateTime.current
      errors.add(:due_date, 'You can\'t complete tasks in the past!')
    end
  end
  
end