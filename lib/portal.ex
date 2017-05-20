defmodule Portal do
  @moduledoc """
  Documentation for Portal.
  """

  defstruct [:left, :right]

  @doc """
  Shoots a new door with the given `color`
  """
  def shoot(color) do
    Supervisor.start_child(Portal.Supervisor, [color])
  end

  @doc """
  Starts transfering `data` from `left` to `right`
  """
  def transfer(left, right, data) do
    # First add all data to the portal on the left
    for item <- data do
      Portal.Door.push(left, item)
    end

    # Returns a portal struct we will use next
    %Portal{left: left, right: right}
  end

  @doc """
  Pushes data to the right in the given portal
  """
  def push_right(portal) do
    push(portal.left, portal.right)
    portal
  end

  def push_left(portal) do
    push(portal.right, portal.left)
    portal
  end

  def push(from_door, to_door) do
    case Portal.Door.pop(from_door) do
      :error -> :ok
      {:ok, item} -> Portal.Door.push(to_door, item)
    end
  end
end

defimpl Inspect, for: Portal do
  def inspect(%Portal{left: left, right: right}, _) do
    left_door = inspect(left)
    right_door = inspect(right)

    left_data = inspect(Enum.reverse(Portal.Door.get(left)))
    right_data = inspect(Portal.Door.get(right))

    max = max(String.length(left_door), String.length(left_data))

    """
    #Portal<
      #{String.rjust(left_door, max)} <=> #{right_door}
      #{String.rjust(left_data, max)} <=> #{right_data}
    >
    """
  end
end
