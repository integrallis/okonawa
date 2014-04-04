describe "Todos Controller" do
  tests TodosController

  before do
    @now = NSDate.new.to_f

    @todo = Todo.new
    @todo.name = 'Buy Milk'
    @todo.details = 'Get some 1% to rid yourself of the muffin top'
    @todo.due_date = @now
    @todo.done = false

    @table = controller.tableView
    @todos = controller.instance_variable_get('@todos')
    @todos << @todo

    controller.refresh_display
  end

  it 'should exist' do
    @table.should.not == nil
  end

  it 'displays the given ToDos' do
    @table.visibleCells.should.not.be.empty
  end

  it 'displays the correct label for a give ToDo' do
    first_cell = @table.visibleCells.first
    first_cell.textLabel.text.should == 'Buy Milk'
  end

  it 'creates a new row for a new todo' do
    todo = controller.add_todo
    controller.add_todo_row(todo)
    last_cell = @table.visibleCells.last
    last_cell.textLabel.text.should == 'New Todo'
  end

  it 'should be able to swipe to delete' do
    @another_todo = Todo.new
    @another_todo.name = 'Buy Beer and Bacon'
    @another_todo.details = 'Undo the first todo'
    @another_todo.due_date = @now
    @another_todo.done = false

    @todos << @another_todo

    controller.refresh_display

    flick 'Buy Beer and Bacon', :from => :right, :to => :left, :duration => 1.0
    tap 'Delete'

    controller.refresh_display

    cells = @table.visibleCells.size
    cells.should == 2 # this bloody test is not working!!!
  end

end
