defmodule Db.Initialize do
  NimbleCSV.define(MyParser, separator: [","], new_lines: ["\r", "\r\n", "\n"])

  def load_all do
    Db.Repo.delete_all(Db.Model.Dish)
    Db.Repo.delete_all(Db.Model.Restaurant)
    load_restaurant()
    load_dish()
  end

  def load_restaurant do
    "restaurants.csv"
    |> file_path(:db)
    |> File.stream!()
    |> MyParser.parse_stream()
    |> Stream.map(fn [
                       restaurant,
                       doordash_url,
                       _grubhub_url,
                       _ubereats_url,
                       _postmates_url,
                       _caviar_url,
                       category,
                       address,
                       phone,
                       website
                     ] ->
      %{
        name: restaurant,
        category: category,
        address: address,
        phone: phone,
        website: website,
        doordash_url: doordash_url
      }
    end)
    |> Stream.map(&scrub/1)
    |> Enum.each(fn param ->
      Db.Repo.insert!(struct(Db.Model.Restaurant, param), on_conflict: :nothing)
    end)
  end

  def load_dish do
    restaurants = Db.Repo.all(Db.Model.Restaurant)

    "dishes.csv"
    |> file_path(:db)
    |> File.stream!()
    |> MyParser.parse_stream()
    |> Stream.map(fn [restaurant, name, image_url, type] ->
      %{
        name: name,
        image_url: image_url,
        type: type,
        restaurant_id: Enum.find(restaurants, &(&1.name == restaurant)).id
      }
    end)
    |> Enum.each(fn param ->
      Db.Repo.insert!(struct(Db.Model.Dish, param), on_conflict: :nothing)
    end)
  end

  defp scrub(params) do
    Stream.map(params, fn
      {k, ""} -> {k, nil}
      {k, " "} -> {k, nil}
      pair -> pair
    end)
    |> Stream.into(%{})
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp file_path(filename, app), do: Path.join([priv_dir(app), "seed", filename])
end
