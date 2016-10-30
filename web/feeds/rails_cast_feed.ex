defmodule Caster.Feed.RailsCastFeed do
  alias Caster.Repo

  @moduledoc """
  This feed parses the RSS feed for railscasts and then
  creates records in the database
  """
  def fetch!(client \\ Caster.Feed.RailsCastFeed.ProdClient) do
    client.fetch!
    |> FeederEx.parse!
    |> Map.get(:entries)
    |> Enum.filter(&(Map.get(&1, :enclosure)))
    |> Enum.each(&insert_record_unless_existing/1)
  end

  defp insert_record_unless_existing(%FeederEx.Entry{title: title, enclosure: %{url: url}, updated: published_at} = _record) do
    episode = Regex.named_captures(~r/#(?<episode>\d+)/, title)["episode"]
    published_at = Timex.parse!(published_at, "{RFC1123}")

    case Repo.get_by(Caster.RailsCast, url: url) do
      %{id: _id} -> nil
      nil -> insert(title, url, published_at, episode)
    end
  end

  defp insert(title, url, published_at, episode) do
    %Caster.RailsCast{}
      |> Caster.RailsCast.changeset(title: title, url: url, published_at: published_at, episode: episode)
      |> Repo.insert!()
  end

  defmodule ProdClient do
    @moduledoc """
      Production client for fetching railscast entries
    """
    @behaviour Caster.FeedClient
    @feed_url "http://feeds.feedburner.com/railscasts"

    def fetch! do
      %HTTPoison.Response{body: body} = HTTPoison.get!(@feed_url)
      body
    end

  end

  defmodule TestClient do
    @moduledoc """
      Mock to save us hitting railscast feed in tests
    """
    @behaviour Caster.FeedClient
    def fetch! do
      ~s|<?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:media="http://search.yahoo.com/mrss/" version="2.0">
  <channel>
    <item>
      <title>#417 Foundation</title>
      <description>ZURB's Foundation is a front-end for quickly building applications and prototypes. It is similar to Twitter Bootstrap but uses Sass instead of LESS. Here you will learn the basics of the grid system, navigation, tooltips and more.</description>
      <pubDate>Sun, 16 Jun 2013 00:00:00 -0700</pubDate>
      <enclosure url="http://media.railscasts.com/assets/episodes/videos/417-foundation.mp4" length="32637739" type="video/mp4" />
      <link>http://railscasts.com/episodes/417-foundation</link>
      <guid isPermaLink="false">foundation</guid>
      <itunes:author>Ryan Bates</itunes:author>
      <itunes:subtitle>ZURB's Foundation is a front-end for quickly building applications and prototypes. It is similar to Twitter Bootstrap but uses Sass instead of LESS...</itunes:subtitle>
      <itunes:summary>ZURB's Foundation is a front-end for quickly building applications and prototypes. It is similar to Twitter Bootstrap but uses Sass instead of LESS. Here you will learn the basics of the grid system, navigation, tooltips and more.</itunes:summary>
      <itunes:explicit>no</itunes:explicit>
      <itunes:duration>11:06</itunes:duration>
    </item>
  </channel>
</rss>
      |
    end
  end
end
