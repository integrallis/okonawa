class Todo
  include ParseModel::Model

  fields :name, :details, :due_date, :done

  def overdue?
    NSDate.new > self.due_date && !done
  end

  def new?
    objectId.nil?
  end

  def valid?
    !name.nil?
  end

  def to_s
    "objectId: #{objectId}, name: #{name}, details: #{details}, due_date: #{due_date}, done: #{done}"
  end
end
