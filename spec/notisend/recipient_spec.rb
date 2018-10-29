require 'spec_helper'

describe Notisend::Recipient do
  describe '.get_all' do
    context 'without params' do
      subject { described_class.get_all(list_id: 1) }
      before { stub_recipient_get_all(1) }
      include_examples 'collection'
      it { expect(subject.collection.first.id).to eq 1 }
      it { expect(subject.collection.first.email).to eq 'email1@example.com' }
      it { expect(subject.collection.first.values.size).to eq 2 }
      it { expect(subject.collection.last.id).to eq 2 }
      it { expect(subject.collection.last.email).to eq 'email2@example.com' }
      it { expect(subject.collection.last.values).to eq [] }
    end

    context 'when params passed' do
      subject { described_class.get_all(list_id: 1, params: { page_size: 1 }) }
      it 'it uses params' do
        stub = stub_recipient_get_all(1, page_size: 1)
        subject
        expect(stub).to have_been_requested
      end
    end
  end

  describe '.create' do
    let(:values) { [{ parameter_id: 1, value: 'John Smith' }] }
    subject { described_class.create(list_id: 1, email: 'email@example.com', values: values) }
    before { stub_recipient_create(1, 'email@example.com', values) }
    it { expect(subject.id).to eq 1 }
    it { expect(subject.email).to eq 'email@example.com' }
    it { expect(subject.list_id).to eq 1 }
    it { expect(subject.values.size).to eq 1 }
  end

  describe '.update' do
    let(:values) { [{ parameter_id: 1, value: 'John Black' }] }
    subject { described_class.update(id: 1, list_id: 1, email: 'new.email@mail.org', values: values) }
    before { stub_recipient_update(1, 1, 'new.email@mail.org', values) }
    it { expect(subject.id).to eq 1 }
    it { expect(subject.email).to eq 'new.email@mail.org' }
    it { expect(subject.list_id).to eq 1 }
    it { expect(subject.values.size).to eq 1 }
  end

  describe '.import' do
    let(:recipients) { [{ email: 'email1@mail.com' }, { email: 'email2@mail.com' }] }
    subject { described_class.import(list_id: 1, recipients: recipients) }
    before { stub_recipient_import(1, recipients) }
    it { expect(subject.id).to eq 1 }
    it { expect(subject.status).to eq 'queued' }
  end
end
