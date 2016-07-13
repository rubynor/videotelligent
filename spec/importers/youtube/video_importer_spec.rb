require 'rails_helper'

RSpec.describe Youtube::VideoImporter do

  let(:content_provider) { build(:content_provider) }
  let(:content_providers) { [content_provider] }
  let(:account) { double }
  let(:content_owner) { double(owner_name: 'CONTENT_OWNER_ID') }
  let(:content_owners) { [content_owner] }
  let(:channel) { double(id: 'CHANNEL_ID') }
  let(:channels) { [channel] }
  let(:video) { double(id: 'VIDEO_ID') }
  let(:videos) { [video] }

  before do
    allow(ContentProvider).to receive(:all).and_return(content_providers)
  end

  describe '#import_all' do
    before :each do
      allow(ContentProvider).to receive(:all).and_return(content_providers)
    end

    it 'imports from all content providers' do
      expect(subject).to receive(:import_for).exactly(content_providers.length).times

      subject.import_all
    end

  end

  describe '#import_for' do

    let(:importer) { double }

    before :each do
      allow(Yt::Account).to receive(:new).and_return(account)
      allow(account).to receive(:content_owners).and_return(content_owners)
      allow(content_owner).to receive(:partnered_channels).and_return(channels)
      allow(channel).to receive(:videos).and_return(videos)
      allow_any_instance_of(Youtube::SingleVideoImporter).to receive(:import_video)
      allow(Youtube::SingleVideoImporter).to receive(:new).and_return(importer)
      allow(importer).to receive(:import_video)
    end

    it 'creates an account using the content owners refresh token' do
      expect(Yt::Account).to receive(:new).with(refresh_token: content_provider.refresh_token)

      subject.import_for(content_provider)
    end

    it 'imports all the accounts content owners' do
      expect(importer).to receive(:import_video).exactly(content_owners.length * channels.length * videos.length).times

      subject.import_for(content_provider)
    end

    context 'with excluded channel ids set' do

      it 'does not import videos from excluded channels' do
        ClimateControl.modify EXCLUDED_CHANNEL_IDS: channel.id do
          subject = Youtube::VideoImporter.new # This is necessary because original subject is created _before_ we modify env

          expect_any_instance_of(Youtube::SingleVideoImporter).to_not receive(:import_video)

          subject.import_for(content_provider)
        end

      end
    end

    it 'skips the video if a 404 exception is encountered' do
      allow(importer).to receive(:import_video).and_raise(Yt::Errors::RequestError.new({response_body: { error: { code: 404 }}}.to_json))

      subject.import_for(content_provider)
    end
  end
end
