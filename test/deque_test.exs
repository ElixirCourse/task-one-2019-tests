defmodule DequeTest do
  use ExUnit.Case, async: false

  @moduletag timeout: 1000
  @moduletag :original

  test "Deque.new create empty deque" do
    assert Deque.new()
  end

  test "the size of empty deque is 0" do
    assert Deque.new() |> Deque.size == 0
  end

  test "when one item is added to an empty deque it size is increased to 1" do
    assert Deque.new() |> Deque.push_back(:new) |> Deque.size == 1
    assert Deque.new() |> Deque.push_front(:new) |> Deque.size == 1
  end

  test "the size of deque with fixed number of elements is properly calculated" do
    assert zero_to_ten() |> Deque.size == 11
  end

  test "first of an empty deque is nil" do
    assert Deque.new() |> Deque.first == nil
  end

  test "last of an empty deque is nil" do
    assert Deque.new() |> Deque.last == nil
  end

  test "when we push element to the back it is the last element" do
    assert zero_to_ten() |> Deque.push_back(:new) |> Deque.last == :new
  end

  test "when we push element to the front it is the first element" do
    assert zero_to_ten() |> Deque.push_front(:new) |> Deque.first == :new
  end

  test "pushing element to the front of empty deque makes the front the same as the back" do
    deque = Deque.new() |> Deque.push_front(:new)
    assert deque |> Deque.first == deque |> Deque.last
  end

  test "pushing element to the back of empty deque makes the front the same as the back" do
    deque = Deque.new() |> Deque.push_back(:new)
    assert deque |> Deque.first == deque |> Deque.last
  end

  test "poping an element from an empty deque does not change the deque" do
    deque = %Deque{}
    assert deque |> Deque.size == 0
    assert deque |> Deque.pop_front == deque
    assert deque |> Deque.pop_back == deque
  end

  test "poping an element from a deque with 1 element returns empty deque" do
    deque = zero_to(0)
    assert deque |> Deque.size == 1
    assert deque |> Deque.pop_front == Deque.new
    assert deque |> Deque.pop_back == Deque.new
  end

  test "poping an element from a non empty deque with fixed size reduces its size by 1" do
    deque = zero_to_ten()
    size = deque |> Deque.size
    assert size > 0
    assert deque |> Deque.pop_back |> Deque.size == size - 1
    assert deque |> Deque.pop_front |> Deque.size == size - 1
  end

  test "can access element at an index" do
    deque = zero_to_ten()
    rand = :rand.uniform(10)
    assert deque |> Deque.access_at(0) == 0
    assert deque |> Deque.access_at(8) == 8
    assert deque |> Deque.access_at(10) == 10
    assert deque |> Deque.access_at(rand) == rand
  end

  test "accessing element out of index range returns nil" do
    deque = zero_to_ten()
    rand = :rand.uniform(10)
    assert deque |> Deque.access_at(-1) == nil
    assert deque |> Deque.access_at(12) == nil
    assert deque |> Deque.access_at(rand + 11) == nil
    assert deque |> Deque.access_at(rand - 11) == nil
  end

  test "access with invalid index breaks" do
    deque = zero_to_ten()
    catch_error deque |> Deque.access_at(1.5)
    catch_error deque |> Deque.access_at(false)
    catch_error deque |> Deque.access_at("5")
  end

  test "can assign value to a concrete index" do
    assert :new ==
      zero_to_ten()
      |> Deque.assign_at(5, :new)
      |> Deque.access_at(5)
  end

  test "assigning to a index out of range breaks" do
    deque = zero_to_ten()
    catch_error deque |> Deque.assign_at(-1)
    catch_error deque |> Deque.assign_at(12)
  end

  test "assign with invalid index breaks" do
    deque = zero_to_ten()
    catch_error deque |> Deque.assign_at(1.5)
    catch_error deque |> Deque.assign_at(false)
    catch_error deque |> Deque.assign_at("5")
  end

  test "Collectable is properly implemented" do
    deque = 0..100 |> Enum.into(Deque.new)
    for x <- 0..100 do
      assert deque |> Deque.access_at(x) == x
    end
  end

  test "Enumerable works for functions that don't depend on ordering" do
    deque = zero_to(100)
    empty = Deque.new()
    rand = :rand.uniform(100)
    assert deque |> Enum.sum == 5050
    assert deque |> Enum.count == 101
    assert deque |> Enum.member?(rand)
    assert empty |> Enum.empty?
    refute deque |> Enum.empty?
  end

  test "Enumerable works for functions that depend on ordering" do
    deque = zero_to(100)
    assert deque |> Enum.to_list == 0..100 |> Enum.to_list
    assert deque |> Enum.join == 0..100 |>  Enum.join
  end

  test "600 000 elements could be pushed to the back" do
    600_000 |> times_do(Deque.new(), &Deque.push_back(&1, :ok))
  end

  test "600 000 elements could be pushed to the front" do
    600_000 |> times_do(Deque.new(), &Deque.push_front(&1, :ok))
  end

  test "150 000 elements with 450 000 random actions" do
    deque = zero_to(149_999)
    450_000 |> times_do({deque, 150_000}, &random_action(&1))
  end

  # Test helpers

  defp zero_to_ten(), do: zero_to(10)

  defp zero_to(deque \\ %Deque{}, n)
  defp zero_to(deque, 0), do: deque |> Deque.push_front(0)
  defp zero_to(deque, n) do
    deque |> Deque.push_front(n) |> zero_to(n - 1)
  end

  defp times_do(0, input, _), do: input
  defp times_do(n, input, func) do
    input = func.(input)
    times_do(n-1, input, func)
  end

  defp random_action(input), do: random_action(input, :rand.uniform())
  defp random_action({deque, _} = input, num) when num < 0.2 do
    deque |> Deque.size()
    input
  end
  defp random_action({deque, size} = input, num) when num < 0.4 do
    deque |> Deque.access_at(:rand.uniform(size) - 1)
    input
  end
  defp random_action({deque, size}, num) when num < 0.6 do
    deque = deque |> Deque.assign_at(:rand.uniform(size) - 1, :new)
    {deque, size}
  end
  defp random_action({deque, size}, num) when num < 0.7 do
    deque = deque |> Deque.push_back(:new)
    {deque, size + 1}
  end
  defp random_action({deque, size}, num) when num < 0.8 do
    deque = deque |> Deque.push_front(:new)
    {deque, size + 1}
  end
  defp random_action({deque, size}, num) when num < 0.9 do
    deque = deque |> Deque.pop_front()
    {deque, size - 1}
  end
  defp random_action({deque, size}, _) do
    deque = deque |> Deque.pop_back()
    {deque, size - 1}
  end
end
