defmodule Db.Initialize do
  NimbleCSV.define(MyParser, separator: [","], new_lines: ["\r", "\r\n", "\n"])

  def load_restaurants do
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
    |> Enum.each(fn param ->
      Db.Repo.insert!(struct(Db.Model.Restaurant, param), on_conflict: :nothing)
    end)
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp file_path(filename, app), do: Path.join([priv_dir(app), "seed", filename])
end
