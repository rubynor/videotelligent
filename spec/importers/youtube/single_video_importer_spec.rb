require 'rails_helper'

RSpec.describe Youtube::SingleVideoImporter do


  let(:yt_video) do
    double({
               id: "1",
               title: "YtVideoTitle",
               view_count: 1000,
               views: { total: 1000 },
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

  let(:subject) { Youtube::SingleVideoImporter.new(yt_video) }

  DEFAULT_COUNTRY = 'NO'
  DEFAULT_COUNTRY_VIEW_COUNT = 1000

  before :each do
    allow(yt_video).to receive(:viewer_percentage).and_return({})
    Timecop.freeze(Time.local(2012))
  end

  after do
    Timecop.return
  end

  context "When the video does not exist" do

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
        allow(yt_video).to receive(:views).with(by: :country, until: 8.days.ago)
                               .and_return({ DEFAULT_COUNTRY => 1000 })
        allow(yt_video).to receive(:viewer_percentage).with(in: { country: DEFAULT_COUNTRY }, until: 8.days.ago)
                               .and_return({ male: { '13-17' => 40.0, '65-' => 60.0 } })

        allow(yt_video).to receive(:views).with(by: :country, since: date, until: date)
                               .and_return({ DEFAULT_COUNTRY => 2000 })

        allow(yt_video).to receive(:viewer_percentage).with(in: { country: DEFAULT_COUNTRY }, until: date, since: date)
                               .and_return({ male: { '13-17' => 70.0, '65-' => 30.0 } })
      end

      it "should create one consolidated viewstat for views older than one week per demographic group for that country" do
        video = subject.import_video

        view_stats = video.view_stats.where(country: DEFAULT_COUNTRY).where(on_date: Youtube::SingleVideoImporter::LONG_TIME_AGO..8.days.ago)
        expect(view_stats.map(&:gender).uniq).to contain_exactly("male")
        expect(view_stats.map(&:age_group)).to contain_exactly("13-17", "65-")
        expect(view_stats.map(&:number_of_views)).to contain_exactly(600, 400)
      end

      it "should have sum of country's viewstats equal to views within that country" do
        video = subject.import_video

        view_stats = video.view_stats.where(country: DEFAULT_COUNTRY).where(on_date: Youtube::SingleVideoImporter::LONG_TIME_AGO..8.days.ago)
        expect(view_stats.map(&:number_of_views).sum).to eq(1000)
      end

      it "should create one viewstat per day we have data for in the last week per demographic group for that country" do
        video = subject.import_video

        view_stats = video.view_stats.where(country: DEFAULT_COUNTRY).where(on_date: 1.week.ago..Date.today)
        expect(view_stats.map(&:gender).uniq).to contain_exactly("male")
        expect(view_stats.map(&:age_group)).to contain_exactly("13-17", "65-")
        expect(view_stats.map(&:number_of_views)).to contain_exactly(1400, 600)
      end

      it "should have sum of country's viewstats equal to views within that country" do
        video = subject.import_video

        view_stats = video.view_stats.where(country: DEFAULT_COUNTRY).where(on_date: 1.week.ago..Date.today)
        expect(view_stats.map(&:number_of_views).sum).to eq(2000)
      end

    end

    context "for countries we don't care about" do

      before do

        views_per_country = {
            DEFAULT_COUNTRY => DEFAULT_COUNTRY_VIEW_COUNT,
            'NON_EXISTING' => 1000,
            'BS_COUNTRY' => 1000
        }
        allow(yt_video).to receive(:views).with(by: :country, until: 8.days.ago)
                               .and_return(views_per_country)
        allow(yt_video).to receive(:viewer_percentage).with(in: {country: DEFAULT_COUNTRY}, until: 8.days.ago)
                               .and_return({ male: { '13-17' => 40.0, '65-' => 60.0 } })
        allow(yt_video).to receive(:viewer_percentage).with(until: 8.days.ago)
                               .and_return({ male: { '13-17' => 40.0, '65-' => 60.0 } })
        allow(yt_video).to receive(:views).with(until: 8.days.ago).and_return({ total: views_per_country.values.sum })


        a_date = 5.days.ago.to_date
        allow(yt_video).to receive(:views).with(by: :country, since: a_date, until: a_date)
                               .and_return(views_per_country)
        allow(yt_video).to receive(:viewer_percentage).with(in: { country: DEFAULT_COUNTRY }, until: a_date, since: a_date)
                               .and_return({ male: { '13-17' => 40.0, '65-' => 60.0 } })
        allow(yt_video).to receive(:viewer_percentage).with(until: a_date, since: a_date)
                               .and_return({ male: { '13-17' => 40.0, '65-' => 60.0 } })
        allow(yt_video).to receive(:views).with(since: a_date, until: a_date).and_return({ total: views_per_country.values.sum })
      end

      it "should have sum of last week's viewstats equal to sum of last week's views in all uninteresting countries" do
        video = subject.import_video
        view_stats = video.view_stats.where(on_date: 1.week.ago..Date.today).where(country: "OTHER")
        expect(view_stats.map(&:number_of_views).sum).to eq(1000 + 1000)
      end

      it "should have sum of baseline viewstats equal to sum of baseline views in all uninteresting countries" do
        video = subject.import_video
        view_stats = video.view_stats.where(on_date: Youtube::SingleVideoImporter::LONG_TIME_AGO..8.days.ago).where(country: "OTHER")

        expect(view_stats.map(&:number_of_views).sum).to eq(1000 + 1000)
      end

      it "should create one viewstat per day we have data per demographic group under country 'OTHER'" do
        video = subject.import_video
        view_stats = video.view_stats.where(on_date: 1.week.ago..Date.today).where(country: "OTHER")

        expect(view_stats.count).to eq(2)
      end

      it "should create consolidated baseline viewstats under country 'OTHER'" do
        video = subject.import_video
        expect(video.view_stats.where(country: "OTHER").where(on_date: Youtube::SingleVideoImporter::LONG_TIME_AGO..8.days.ago).map(&:number_of_views)).to contain_exactly(800, 1200)
      end

    end


  end

end
