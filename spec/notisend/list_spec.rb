require 'spec_helper'

describe Notisend::List do
  describe '.get_all' do
    context 'without params' do
      subject { described_class.get_all }
      before { stub_list_get_all }
      include_examples 'collection'
      it { expect(subject.collection.first.id).to eq 1 }
      it { expect(subject.collection.first.title).to eq 'List #1' }
      it { expect(subject.collection.last.id).to eq 2 }
      it { expect(subject.collection.last.title).to eq 'List #2' }
    end

    context 'when params passed' do
      subject { described_class.get_all(params: { page_size: 1 }) }
      it 'it uses params' do
        stub = stub_list_get_all(page_size: 1)
        subject
        expect(stub).to have_been_requested
      end
    end
  end

  describe '.create' do
    subject { described_class.create(title: 'New List') }
    before { stub_list_create('New List') }
    it { expect(subject.id).to eq 1 }
    it { expect(subject.title).to eq 'New List' }
  end

  describe '.get' do
    subject { described_class.get(id: 1) }
    before { stub_list_get(1) }
    it { expect(subject.id).to eq 1 }
    it { expect(subject.title).to eq 'List' }
  end
end
