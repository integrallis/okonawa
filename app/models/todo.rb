class Todo
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter

  columns :name     => :string,
          :details  => :string,
          :due_date => {:type => :date, :formotion => {:picker_type => :date_time}},
          :done     => {:type => :boolean, :default => false, :formotion => {:type => :switch}}
end