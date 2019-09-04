# frozen_string_literal: true
require 'spec_helper'

describe Gitlab::FileTypeDetection do
  context 'when class is an uploader' do
    let(:uploader) do
      example_uploader = Class.new(CarrierWave::Uploader::Base) do
        include Gitlab::FileTypeDetection

        storage :file
      end

      example_uploader.new
    end

    def upload_fixture(filename)
      fixture_file_upload(File.join('spec', 'fixtures', filename))
    end

    describe '#image?' do
      it 'returns true for an image file' do
        uploader.store!(upload_fixture('dk.png'))

        expect(uploader).to be_image
      end

      it 'returns false if filename has a dangerous image extension' do
        uploader.store!(upload_fixture('unsanitized.svg'))

        expect(uploader).to be_dangerous_image
        expect(uploader).not_to be_image
      end

      it 'returns false for a video file' do
        uploader.store!(upload_fixture('video_sample.mp4'))

        expect(uploader).not_to be_image
      end

      it 'returns false if filename is blank' do
        uploader.store!(upload_fixture('dk.png'))

        allow(uploader).to receive(:filename).and_return(nil)

        expect(uploader).not_to be_image
      end
    end

    describe '#image_or_video?' do
      it 'returns true for an image file' do
        uploader.store!(upload_fixture('dk.png'))

        expect(uploader).to be_image_or_video
      end

      it 'returns true for a video file' do
        uploader.store!(upload_fixture('video_sample.mp4'))

        expect(uploader).to be_image_or_video
      end

      it 'returns false when file has a dangerous extension' do
        uploader.store!(upload_fixture('unsanitized.svg'))

        expect(uploader).to be_dangerous_image_or_video
        expect(uploader).not_to be_image_or_video
      end

      it 'returns false for other extensions' do
        uploader.store!(upload_fixture('doc_sample.txt'))

        expect(uploader).not_to be_image_or_video
      end

      it 'returns false if filename is blank' do
        uploader.store!(upload_fixture('dk.png'))

        allow(uploader).to receive(:filename).and_return(nil)

        expect(uploader).not_to be_image_or_video
      end
    end

    describe '#dangerous_image?' do
      it 'returns true if filename has a dangerous extension' do
        uploader.store!(upload_fixture('unsanitized.svg'))

        expect(uploader).to be_dangerous_image
      end

      it 'returns false for an image file' do
        uploader.store!(upload_fixture('dk.png'))

        expect(uploader).not_to be_dangerous_image
      end

      it 'returns false for a video file' do
        uploader.store!(upload_fixture('video_sample.mp4'))

        expect(uploader).not_to be_dangerous_image
      end

      it 'returns false if filename is blank' do
        uploader.store!(upload_fixture('dk.png'))

        allow(uploader).to receive(:filename).and_return(nil)

        expect(uploader).not_to be_dangerous_image
      end
    end
  end

  context 'when class is a regular class' do
    let(:custom_class) do
      custom_class = Class.new do
        include Gitlab::FileTypeDetection
      end

      custom_class.new
    end

    describe '#image?' do
      it 'returns true for an image file' do
        allow(custom_class).to receive(:filename).and_return('dk.png')

        expect(custom_class).to be_image
      end

      it 'returns false if file has a dangerous image extension' do
        allow(custom_class).to receive(:filename).and_return('unsanitized.svg')

        expect(custom_class).to be_dangerous_image
        expect(custom_class).not_to be_image
      end

      it 'returns false for any non image file' do
        allow(custom_class).to receive(:filename).and_return('video_sample.mp4')

        expect(custom_class).not_to be_image
      end

      it 'returns false if filename is blank' do
        allow(custom_class).to receive(:filename).and_return(nil)

        expect(custom_class).not_to be_image
      end
    end

    describe '#image_or_video?' do
      it 'returns true for an image file' do
        allow(custom_class).to receive(:filename).and_return('dk.png')

        expect(custom_class).to be_image_or_video
      end

      it 'returns true for a video file' do
        allow(custom_class).to receive(:filename).and_return('video_sample.mp4')

        expect(custom_class).to be_image_or_video
      end

      it 'returns false if file has a dangerous extension' do
        allow(custom_class).to receive(:filename).and_return('unsanitized.svg')

        expect(custom_class).to be_dangerous_image_or_video
        expect(custom_class).not_to be_image_or_video
      end

      it 'returns false for other extensions' do
        allow(custom_class).to receive(:filename).and_return('doc_sample.txt')

        expect(custom_class).not_to be_image_or_video
      end

      it 'returns false if filename is blank' do
        allow(custom_class).to receive(:filename).and_return(nil)

        expect(custom_class).not_to be_image_or_video
      end
    end

    describe '#dangerous_image?' do
      it 'returns true if file has a dangerous image extension' do
        allow(custom_class).to receive(:filename).and_return('unsanitized.svg')

        expect(custom_class).to be_dangerous_image
      end

      it 'returns false for an image file' do
        allow(custom_class).to receive(:filename).and_return('dk.png')

        expect(custom_class).not_to be_dangerous_image
      end

      it 'returns false for any non image file' do
        allow(custom_class).to receive(:filename).and_return('video_sample.mp4')

        expect(custom_class).not_to be_dangerous_image
      end

      it 'returns false if filename is blank' do
        allow(custom_class).to receive(:filename).and_return(nil)

        expect(custom_class).not_to be_dangerous_image
      end
    end
  end
end
