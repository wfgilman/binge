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
                       name,
                       phone,
                       address,
                       website,
                       doordash_url,
                       instagram,
                       filename
                     ] ->
      %{
        name: name,
        address: address,
        phone: phone,
        website: website,
        doordash_url: doordash_url,
        instagram: instagram,
        filename: filename
      }
    end)
    |> Stream.map(&scrub/1)
    |> Enum.each(fn param ->
      Db.Repo.insert!(struct(Db.Model.Restaurant, param), on_conflict: :nothing)
    end)
  end

  def load_dish do
    restaurants = Db.Repo.all(Db.Model.Restaurant)

    "images.csv"
    |> file_path(:db)
    |> File.stream!()
    |> MyParser.parse_stream()
    |> Stream.map(fn [filename] ->
      [restaurant_filename | tail] = String.split(filename, "-")
      [dish_filename | _] = tail

      dish_name =
        dish_filename
        |> String.replace([".jpg", ".jpeg"], "")
        |> String.split("_")
        |> capitalize()
        |> Enum.join(" ")

      %{
        name: dish_name,
        image_name: filename,
        restaurant_id: Enum.find(restaurants, &(&1.filename == restaurant_filename)).id
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

  defp capitalize(list_of_words) do
    Enum.map(list_of_words, fn word ->
      skip = ["a", "the", "and", "an", "with", "in"]
      if word in skip, do: word, else: String.capitalize(word)
    end)
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp file_path(filename, app), do: Path.join([priv_dir(app), "seed", filename])
end
