require 'spec_helper'

describe Notisend::Parameter do
  describe '.get_all' do
    context 'without params' do
      subject { described_class.get_all(list_id: 1) }
      before { stub_parameter_get_all(1) }
      include_examples 'collection'
      it { expect(subject.collection.first.id).to eq 1 }
      it { expect(subject.collection.first.title).to eq 'Name' }
      it { expect(subject.collection.first.kind).to eq 'string' }
      it { expect(subject.collection.last.id).to eq 2 }
      it { expect(subject.collection.last.title).to eq 'Age' }
      it { expect(subject.collection.last.kind).to eq 'numeric' }
    end

    context 'when params passed' do
      subject { described_class.get_all(list_id: 1, params: { page_size: 1 }) }
      it 'it uses params' do
        stub = stub_parameter_get_all(1, page_size: 1)
        subject
        expect(stub).to have_been_requested
      end
    end
  end

  describe '.create' do
    subject { described_class.create(title: 'Color', kind: 'string', list_id: 1) }
    before { stub_parameter_create(1, 'string', 'Color') }
    it { subject }
    it { expect(subject.id).to eq 1 }
    it { expect(subject.title).to eq 'Color' }
    it { expect(subject.kind).to eq 'string' }
    it { expect(subject.list_id).to eq 1 }
  end
end
