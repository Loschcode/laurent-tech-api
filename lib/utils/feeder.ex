defmodule FeedApi.Utils.Feeder do

  @doc """
  We try to get the tweets from the timeline of the user
  It will fetch all the needed entry and return them into an array
  """
  def feed!, do: from_twitter!

  def from_twitter! do
    FeedApi.Scrappers.Twitter.dispatch! |> fetch!
  end

  defp fetch!(data) do
    for entry <- data do
      if entry |> valid? do
        change_entry!(FeedApi.Repo.get_by(FeedApi.Link, title: entry.message), entry)
      end
    end
  end

  defp valid?(%{link: nil}), do: false
  defp valid?(%{message: nil}), do: false
  defp valid?(%{message: ""}), do: false
  defp valid?(_), do: true

  defp change_entry!(nil, entry) do
    # let's insert this entry
    FeedApi.Repo.insert! %FeedApi.Link{
      title: entry.message,
      description: nil,
      url: entry.link,
      source: "twitter",
      published_at: entry.date
    }
  end

  defp change_entry!(link, entry) do
    # let's update this entry
    FeedApi.Repo.update! FeedApi.Link.changeset(link, %{
      title: entry.message,
      description: nil,
      url: entry.link,
      source: "twitter",
    })
  end

end
