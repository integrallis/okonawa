class TodoController < Formotion::FormController
  attr_accessor :todo
  attr_accessor :form
  
  def initialize(todo)
    self.form = Formotion::Form.new(todo.to_formotion('Edit your ToDo'))
    self.initWithForm(self.form)
    self.todo = todo
  end

end