require 'google/apis/civicinfo_v2'
require 'csv'
require 'erb'

# make zipcodes prettier
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

# find legislator by zipcode, using Google civic API
def legislators_by_zipcode(service, zipcode)
  begin
    service.representative_info_by_address(
      address: zipcode,
      levels: 'country',
      roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
  rescue
    'No representatives'
  end
end

# Save result to thank you "email template"
def save_thank_you_letter(form_letter, id)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def main
  puts 'Event manager started.'

  civic_info = Google::Apis::CivicinfoV2
  service = civic_info::CivicInfoService.new
  service.key = "AIzaSyDj9cbKwEovjrwjE13T470x-BqeqH8iExg"

  template_letter = File.read('form_letter.erb')
  erb_template = ERB.new(template_letter)

  contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)
  contents.each do |row|
    id = row[0]
    name = row[:first_name]
    zipcode = clean_zipcode(row[:zipcode])

    # Get the legislator from Google civic
    legislators = legislators_by_zipcode(service, zipcode)

    form_letter = erb_template.result(binding)

    # save the content to the corresponding thank you letter
    save_thank_you_letter(form_letter, id)
  end
end

main
