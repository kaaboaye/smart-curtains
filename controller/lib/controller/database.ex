use Amnesia

defdatabase Controller.Database do
  deftable Setting, [:key, :value, :updated_at], type: :set do
    @type t :: %Controller.Database.Setting{
            key: String.t(),
            value: any,
            updated_at: DateTime.t()
          }
  end

  deftable Task, [:id, :desired_value, :scheduled_at, :updated_at], type: :set do
    @type t :: %Controller.Database.Task{
            id: Controller.UniqueId.t(),
            desired_value: float,
            scheduled_at: Time.t(),
            updated_at: DateTime.t()
          }
  end
end
