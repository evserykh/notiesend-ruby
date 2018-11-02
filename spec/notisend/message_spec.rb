require 'spec_helper'

describe Notisend::Message do
  describe '.deliver' do
    let(:files) { [File.expand_path('../fixtures/file.txt', __dir__)] }
    let(:options) do
      {
        from_email: 'sender@mail.com',
        to: 'recipient@mail.com',
        subject: 'Hello',
        text: 'World',
        html: '<h1>World</h1>'
      }
    end
    subject { described_class.deliver(options.merge(attachments: files)) }
    before { stub_message_deliver(options, files) }
    include_examples 'message deliver'
    it { expect(subject.status).to eq 'queued' }
    it { expect(subject.events).to eq({}) }
  end

  describe '.get' do
    subject { described_class.get(id: 1) }
    before { stub_message_get(1) }
    include_examples 'message deliver'
    it { expect(subject.status).to eq 'delivered' }
    it { expect(subject.events).to eq('open' => 1) }
  end

  describe '.template_deliver' do
    subject { described_class.deliver_template(template_id: 1, to: 'recipient@mail.com') }
    before { stub_message_deliver_template(1, 'recipient@mail.com') }
    it { expect(subject.id).to eq 1 }
    it { expect(subject.payment).to eq 'subscriber' }
    it { expect(subject.to).to eq 'recipient@mail.com' }
    it { expect(subject.status).to eq 'queued' }
  end
end
