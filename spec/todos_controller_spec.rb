describe "Todos Controller" do
  before do
    @app = UIApplication.sharedApplication
    @delegate = @app.delegate
    @table = @delegate.instance_variable_get("@table")
  end
  
  it 'should exist' do
    @table.should.not == nil
  end
end