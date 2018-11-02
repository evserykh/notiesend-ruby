shared_examples 'collection' do |size = 2, total_count = 2, total_pages = 1, page_number = 1, page_size = 25|
  it { expect(subject.collection.size).to eq size }
  it { expect(subject.total_count).to eq total_count }
  it { expect(subject.total_pages).to eq total_pages }
  it { expect(subject.page_number).to eq page_number }
  it { expect(subject.page_size).to eq page_size }
end

shared_examples 'message deliver' do
  it { expect(subject.id).to eq 1 }
  it { expect(subject.payment).to eq 'subscriber' }
  it { expect(subject.from_email).to eq 'sender@mail.com' }
  it { expect(subject.from_name).to eq 'Sender' }
  it { expect(subject.to).to eq 'recipient@mail.com' }
  it { expect(subject.subject).to eq 'Subject' }
  it { expect(subject.text).to eq 'Text content' }
  it { expect(subject.html).to eq '<h1>Html content</h1>' }
  it { expect(subject.attachments).to eq ['file.txt'] }
end
