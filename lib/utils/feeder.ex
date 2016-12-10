defmodule FeedApi.Utils.Feeder do

  @doc """
  We try to get the tweets from the timeline of the user
  It will fetch all the needed datas and return them into an array
  """
  def feed! do
    from_twitter!
  end

  def from_twitter! do

    tweets = FeedApi.Scrappers.Twitter.dispatch!

    for tweet <- tweets do

      if tweet.link != nil && tweet.message != nil && tweet.message != "" do

        change_data!(FeedApi.Repo.get_by(FeedApi.Link, title: tweet.message), tweet)

      end

    end

  end

  defp change_data!(link, data) do

    if link == nil do

      # let's insert this entry
      FeedApi.Repo.insert! %FeedApi.Link{
        title: data.message,
        description: nil,
        url: data.link,
        source: "twitter",
        published_at: data.date
      }

    else

      # let's update this entry
      FeedApi.Repo.update! FeedApi.Link.changeset(link, %{
        title: data.message,
        description: nil,
        url: data.link,
        source: "twitter",
      })

    end

  end


end
