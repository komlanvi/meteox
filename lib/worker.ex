defmodule Meteox.Worker do
  @moduledoc"""
  Worker to call the openweather API
  """

  def temperature_of(location) do
    response = location
    |> url_of
    |> HTTPoison.get
    |> parse_response

    case response do
      {:ok, temp} -> "#{location}: #{temp}°C"
      {:error, error_message} -> error_message
    end
  end

  def url_of(location) do
    location
    |> URI.encode
    |> fn location ->
      "api.openweathermap.org/data/2.5/weather?q=#{location}&APPID=#{apikey()}"
    end.()
  end

  def parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body
    |> JSON.decode!
    |> compute_weather
  end
  def parse_response({:ok, %HTTPoison.Response{status_code: 404}}), do: {:error, "Location not found"}
  def parse_response(_), do: {:error, "Something went wong"}

  def compute_weather(payload) do
    payload
    |> get_in([Access.key!("main"), Access.key!("temp")])
    |> fn temp -> temp - 273.15 end.()
    |> Float.ceil(2)
    |> (&({:ok, &1})).()
  end

  defp apikey do
    "261b68a7edde1fdb47ae3c8201b991a3"
  end
end