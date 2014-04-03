describe "Todo Controller" do
  tests TodoController

  before do
    @form = @controller.instance_variable_get("@form")
    @name_row = @form.sections[0].rows[0]
    @details_row = @form.sections[0].rows[1]
    @due_date_row = @form.sections[0].rows[2]
    @done_row = @form.sections[0].rows[3]
  end

  def controller
    unless @controller
      @now = NSDate.new

      @todo = Todo.new
      @todo.name = 'Buy Milk'
      @todo.details = 'We need some Milk'
      @todo.due_date = @now.to_f
      @todo.done = false

      @controller = TodoController.new(@todo)
    end
    @controller
  end

  it "exists" do
    Object.const_defined?('TodoController').should.be.true
  end

  it "displays a Todo's details" do
    @name_row.value.should == 'Buy Milk'
    @details_row.value.should == 'We need some Milk'
    @due_date_row.object.date_value.hour.should == @now.hour
    @due_date_row.object.date_value.min.should == @now.min
    @done_row.value.should == false
  end

  it "saves changes made to a todo" do
    @name_row.object.row.text_field.text = 'Buy 1% Milk'
    controller.save

    @todo.name.should.equal 'Buy 1% Milk'
  end

end
