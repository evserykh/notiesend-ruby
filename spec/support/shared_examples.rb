shared_examples 'collection' do |size = 2, total_count = 2, total_pages = 1, page_number = 1, page_size = 25|
  it { expect(subject.collection.size).to eq size }
  it { expect(subject.total_count).to eq total_count }
  it { expect(subject.total_pages).to eq total_pages }
  it { expect(subject.page_number).to eq page_number }
  it { expect(subject.page_size).to eq page_size }
end
