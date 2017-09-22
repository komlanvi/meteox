defmodule Meteox.WorkerTest do
  use ExUnit.Case
  doctest Meteox.Worker
  alias Meteox.Worker

  test "Request the temperature of London" do
    response  = Worker.temperature_of("London")
    london    = response
    |> String.split(":")
    |> Kernel.hd

    assert "London" === london
  end

  test "Request the temperature of a mysterious city" do
    assert "Location not found" === Worker.temperature_of("adhhnjfjidfoifs")
  end

  test "Unable to handle a request without a parameter" do
    assert "Something went wong" === Worker.temperature_of("")
  end
end