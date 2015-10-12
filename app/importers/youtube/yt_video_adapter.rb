module Youtube
  class YtVideoAdapter < SimpleDelegator

    BASELINE_DATE = 8.days.ago

    def dates_with_no_views
      views_by_day.select { |_, v| v.nil? }.keys
    end

    def views_by_day
      views(by: :day)
    end

    def baseline_views_by_country
      views(by: :country, until: BASELINE_DATE)
    end

    def total_baseline_views
      views(until: BASELINE_DATE)[:total]
    end

    def baseline_viewer_percentage_in(country)
      viewer_percentage(in: { country: country }, until: BASELINE_DATE)
    end

    def baseline_viewer_percentage
      viewer_percentage(until: BASELINE_DATE)
    end

    def day_views_by_country(day)
      views(by: :country, since: day, until: day)
    end

    def day_viewer_percentage_in(country, day)
      viewer_percentage(in: { country: country }, since: day, until: day)
    end

    def last_weeks_viewer_percentage_in(country)
      viewer_percentage(in: { country: country }, since: 1.week.ago)
    end

    def total_viewer_percentage_in(country)
      viewer_percentage(in: { country: country })
    end

    def day_viewer_percentage(day)
      viewer_percentage(since: day, until: day)
    end

    def last_weeks_viewer_percentage
      viewer_percentage(since: 1.week.ago)
    end

    def total_views_on(day)
      views(since: day, until: day)[:total]
    end

  end
end