class TodoController < Formotion::FormController
  attr_accessor :todo
  attr_accessor :form

  def initialize(todo)
    self.form = Formotion::Form.new
    self.form.build_section do |section|
      section.title = "Edit your Todo"

      section.build_row do |row|
        row.title = "Name"
        row.key = :name
        row.type = :string
        row.placeholder = 'Name your Todo'
        row.auto_correction = :no
        row.auto_capitalization = :none
        row.value = todo.name
      end

      section.build_row do |row|
        row.title = "Details"
        row.key = :details
        row.type = :string
        row.placeholder = 'Describe your Todo'
        row.value = todo.details
      end

      section.build_row do |row|
        row.title = "Due Date"
        row.key = :due_date
        row.type = :date
        row.value = todo.due_date
      end

      section.build_row do |row|
        row.title = "Done?"
        row.key = :done
        row.type = :switch
        row.value = todo.done
      end
    end

    self.initWithForm(self.form)
    self.todo = todo
  end

  def viewDidLoad
    super
    saveButton = UIBarButtonItem.alloc.initWithTitle("Save", style: UIBarButtonItemStyleBordered, target:self, action:'save')
    self.navigationItem.rightBarButtonItem = saveButton
  end

  def save
    data = @form.render

    @todo.name = data[:name]
    @todo.details = data[:details]
    @todo.due_date = data[:due_date]
    @todo.done = data[:done]

    @todo.saveEventually unless RUBYMOTION_ENV == 'test'

    app = UIApplication.sharedApplication
    delegate = app.delegate
    controller = delegate.instance_variable_get("@todos_controller")

    if @todo.new?
      controller.add_todo_row(@todo)
    else
      controller.refresh_row_for(@todo)
    end

    view = controller.tableView
    view.setNeedsDisplay

    self.navigationController.popToRootViewControllerAnimated(true) unless RUBYMOTION_ENV == 'test'
  end
end
