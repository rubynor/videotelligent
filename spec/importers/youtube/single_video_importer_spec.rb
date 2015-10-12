require 'rails_helper'

RSpec.describe Youtube::SingleVideoImporter do


  let(:yt_video) do
    double({
               id: "1",
               title: "YtVideoTitle",
               view_count: 10000,
               views: { total: 10000 },
               like_count: 1,
               dislike_count: 1,
               thumbnail_url: "YtVideoThumbnailUrl",
               description: "YtVideoDesc",
               published_at: Date.new(2015, 1, 1),
               channel_title: "YtVideoChannelTitle",
               channel_id: "1",
               category_id: 1,
               tags: [],
           })
  end

  let(:interesting_countries) { %w(NO SE)}
  let(:subject) { Youtube::SingleVideoImporter.new(yt_video, interesting_countries) }

  DEFAULT_COUNTRY = 'NO'
  DEFAULT_COUNTRY_VIEW_COUNT = 10000
  TOO_SMALL_VIEWCOUNT_TO_BE_INTERESTING = 40

  before :each do
    allow(yt_video).to receive(:baseline_viewer_percentage).and_return({})
    allow(yt_video).to receive(:baseline_views_by_country).and_return({})
    allow(yt_video).to receive(:total_baseline_views).and_return(10000)
    allow(yt_video).to receive(:dates_with_no_views).and_return([])
    allow(yt_video).to receive(:day_viewer_percentage).and_return([])
    allow(yt_video).to receive(:day_views_by_country).and_return({})
    allow(yt_video).to receive(:total_views_on).and_return(150)
    allow(yt_video).to receive(:last_weeks_viewer_percentage).and_return({})

    Timecop.freeze(Time.local(2012))
  end

  after do
    Timecop.return
  end

  context "When the video does not exist" do
    let(:within_last_week) { 1.week.ago..Date.today }
    let(:before_last_week) { Youtube::SingleVideoImporter::LONG_TIME_AGO..8.days.ago }

    it "should create a video" do
      expect {
        subject.import_video
      }.to change { Video.count }.by(1)
    end

    context "and the videos view count is lower than the threshold"
    it "should do nothing" do
      allow(yt_video).to receive(:view_count).and_return(0)

      expect {
        subject.import_video
      }.to_not change { Video.count }
    end

    it "should map all fields" do
      video = subject.import_video
      expect(video.uid).to eq(yt_video.id)
      expect(video.title).to eq(yt_video.title)
      expect(video.likes).to eq(yt_video.like_count)
      expect(video.dislikes).to eq(yt_video.dislike_count)
      expect(video.thumbnail_url).to eq(yt_video.thumbnail_url)
      expect(video.description).to eq(yt_video.description)
      expect(video.published_at).to eq(yt_video.published_at)
      expect(video.channel_title).to eq(yt_video.channel_title)
      expect(video.channel_id).to eq(yt_video.channel_id)
      expect(video.tags).to eq(yt_video.tags)
    end

    context "and we have one interesting country only" do

      before do
        date = 5.days.ago.to_date
        allow(yt_video).to receive(:baseline_views_by_country).and_return({ DEFAULT_COUNTRY => DEFAULT_COUNTRY_VIEW_COUNT })
        allow(yt_video).to receive(:baseline_viewer_percentage_in).with(DEFAULT_COUNTRY).and_return({ male: { '13-17' => 40.0, '65-' => 60.0 } })
        allow(yt_video).to receive(:day_views_by_country).with(date).and_return({ DEFAULT_COUNTRY => 20000 })
        allow(yt_video).to receive(:day_viewer_percentage_in).with(DEFAULT_COUNTRY, date).and_return({ male: { '13-17' => 70.0, '65-' => 30.0 } })
      end

      it "should create one consolidated viewstat for views older than one week per demographic group for that country" do
        video = subject.import_video

        view_stats = video.view_stats.where(country: DEFAULT_COUNTRY).where(on_date: before_last_week)
        expect(view_stats.map(&:gender).uniq).to contain_exactly("male")
        expect(view_stats.map(&:age_group)).to contain_exactly("13-17", "65-")
        expect(view_stats.map(&:number_of_views)).to contain_exactly(6000, 4000)
      end

      it "should have sum of country's viewstats equal to views within that country" do
        video = subject.import_video

        view_stats = video.view_stats.where(country: DEFAULT_COUNTRY).where(on_date: before_last_week)
        expect(view_stats.map(&:number_of_views).sum).to eq(DEFAULT_COUNTRY_VIEW_COUNT)
      end

      it "should create one viewstat per day we have data for in the last week per demographic group for that country" do
        video = subject.import_video

        view_stats = video.view_stats.where(country: DEFAULT_COUNTRY).where(on_date: within_last_week)
        expect(view_stats.map(&:gender).uniq).to contain_exactly("male")
        expect(view_stats.map(&:age_group)).to contain_exactly("13-17", "65-")
        expect(view_stats.map(&:number_of_views)).to contain_exactly(14000, 6000)
      end

      it "should have sum of country's viewstats equal to views within that country" do
        video = subject.import_video

        expect(video.views_where(country: DEFAULT_COUNTRY, on_date: within_last_week)).to eq(20000)
      end

      it "should use last week's viewer demographics for consolidated viewstats when they do not exist for a given day" do
        allow(yt_video).to receive(:day_viewer_percentage).and_return({})
        expect(yt_video).to receive(:last_weeks_viewer_percentage).and_return({ male: { '13-17' => 70.0, '65-' => 30.0 } })

        subject.import_video
      end

    end

    context "for countries we don't care about" do

      let(:a_date) { 5.days.ago.to_date }

      before do

        views_per_country = {
            DEFAULT_COUNTRY => DEFAULT_COUNTRY_VIEW_COUNT,
            'NON_EXISTING' => 10000,
            'BS_COUNTRY' => 10000
        }

        views_by_day = (1.week.ago.to_date...Date.today).map { |date| [date, nil] }.to_h
        views_by_day[a_date] = views_per_country.values.sum

        allow(yt_video).to receive(:baseline_views_by_country).and_return(views_per_country)
        allow(yt_video).to receive(:baseline_viewer_percentage_in).with(DEFAULT_COUNTRY).and_return({ male: { '13-17' => 40.0, '65-' => 60.0 } })
        allow(yt_video).to receive(:baseline_viewer_percentage).and_return({ male: { '13-17' => 40.0, '65-' => 60.0 } })
        allow(yt_video).to receive(:total_baseline_views).and_return(views_per_country.values.sum)

        allow(yt_video).to receive(:views_by_day).and_return(views_by_day)
        allow(yt_video).to receive(:day_views_by_country).with(a_date).and_return(views_per_country)
        allow(yt_video).to receive(:day_viewer_percentage_in).with(DEFAULT_COUNTRY, a_date).and_return({ male: { '13-17' => 40.0, '65-' => 60.0 } })
        allow(yt_video).to receive(:day_viewer_percentage).with(a_date).and_return({ male: { '13-17' => 40.0, '65-' => 60.0 } })
        allow(yt_video).to receive(:total_views_on).with(a_date).and_return(views_per_country.values.sum)
      end

      it "should have sum of last week's viewstats equal to sum of last week's views in all uninteresting countries" do
        video = subject.import_video

        expect(video.views_where(on_date: within_last_week, country: "OTHER")).to eq(10000 + 10000)
      end

      it "should have sum of baseline viewstats equal to sum of baseline views in all uninteresting countries" do
        video = subject.import_video

        expect(video.views_where(on_date: before_last_week, country: "OTHER")).to eq(10000 + 10000)
      end

      it "should create one viewstat per day we have data per demographic group under country 'OTHER'" do
        video = subject.import_video
        view_stats = video.view_stats.where(on_date: within_last_week, country: "OTHER")

        expect(view_stats.count).to eq(2)
      end

      it "should create consolidated baseline viewstats under country 'OTHER'" do
        video = subject.import_video
        expect(video.view_stats.where(country: "OTHER", on_date: before_last_week).map(&:number_of_views)).to contain_exactly(8000, 12000)
      end

      it "should only fetch viewer percentage for days that actually has any views" do
        the_day_before = a_date - 1.day
        allow(yt_video).to receive(:dates_with_no_views).and_return([the_day_before])
        expect(yt_video).to receive(:total_views_on).with(a_date)
        expect(yt_video).not_to receive(:total_views_on).with(the_day_before)

        subject.import_video
      end

    end

    context "when we have countries with less than 5000 baseline views" do
      let(:too_small_viewcount_to_be_interesting) { 1600 }
      let(:another_country_we_care_about) { "SE" }
      let(:views_per_country) {
        {
            DEFAULT_COUNTRY => DEFAULT_COUNTRY_VIEW_COUNT,
            'NON_EXISTING' => 10000,
            another_country_we_care_about => too_small_viewcount_to_be_interesting
        }
      }

      before do
        total_views = views_per_country.values.sum
        DEFAULT_DEMOGRAPHY = { male: { '13-17' => 40.0, '65-' => 60.0 } }

        allow(yt_video).to receive(:baseline_views_by_country).and_return(views_per_country)
        allow(yt_video).to receive(:baseline_viewer_percentage_in).with(DEFAULT_COUNTRY).and_return(DEFAULT_DEMOGRAPHY)
        allow(yt_video).to receive(:baseline_viewer_percentage_in).with(another_country_we_care_about).and_return(DEFAULT_DEMOGRAPHY)
        allow(yt_video).to receive(:baseline_viewer_percentage).and_return(DEFAULT_DEMOGRAPHY)
        allow(yt_video).to receive(:total_baseline_views).and_return(total_views)

        a_date = 5.days.ago.to_date
        allow(yt_video).to receive(:day_views_by_country).with(a_date).and_return(views_per_country)
        allow(yt_video).to receive(:day_viewer_percentage_in).with(DEFAULT_COUNTRY, a_date).and_return(DEFAULT_DEMOGRAPHY)
        allow(yt_video).to receive(:day_viewer_percentage_in).with(another_country_we_care_about, a_date).and_return(DEFAULT_DEMOGRAPHY)
        allow(yt_video).to receive(:day_viewer_percentage).with(a_date).and_return(DEFAULT_DEMOGRAPHY)
        allow(yt_video).to receive(:total_views_on).with(a_date).and_return(total_views)
      end

      it "should not include those countries as separate baseline country viewstats" do
        video = subject.import_video
        view_stats = video.view_stats.where(on_date: before_last_week).where.not(country: "OTHER")

        expect(view_stats.map(&:number_of_views).sum).to eq(views_per_country[DEFAULT_COUNTRY])
      end

      it "should include those countries in the consolidated baseline viewstats" do
        video = subject.import_video
        view_stats = video.view_stats.where(on_date: before_last_week, country: "OTHER")

        puts view_stats.inspect
        puts video.view_stats.awesome_inspect

        expect(view_stats.map(&:number_of_views).sum).to eq(10000 + too_small_viewcount_to_be_interesting)
      end

      it "should not include those countries in the weekly country-wise viewstats" do
        video = subject.import_video
        view_stats = video.view_stats.where(on_date: within_last_week).where.not(country: "OTHER")


        expect(view_stats.map(&:number_of_views).sum).to eq(DEFAULT_COUNTRY_VIEW_COUNT)
      end

      it "should include those countries in the weekly consolidated viewstats" do
        video = subject.import_video
        view_stats = video.view_stats.where(on_date: within_last_week).where(country: "OTHER")

        expect(view_stats.map(&:number_of_views).sum).to eq(10000 + too_small_viewcount_to_be_interesting)
      end

    end

  end

  context "When the video exists" do

    before :each do
      @video = create(:video, uid: yt_video.id)
      create(:view_stat, video: @video, on_date: 3.days.ago, country: "NO")
      allow(yt_video).to receive(:views_by_day).and_return(3.days.ago.to_date => 10, 2.days.ago.to_date => 20, 1.days.ago.to_date => nil)
      allow(yt_video).to receive(:day_viewer_percentage).and_return({ male: { '13-17' => 70.0, '65-' => 30.0 } })
      allow(yt_video).to receive(:total_views_on).and_return(20)
    end

    it "should add the day-wise viewstats for the days that is missing" do
      video = subject.import_video

      expect(video.views_where(on_date: 2.days.ago)).to be > 0
    end

    it "should only import day-wise viewstats for interesting countries" do
      video = subject.import_video

      expect(video.view_stats.where(on_date: 2.days.ago).map(&:country)).not_to include("SE")
    end

  end

end
