namespace :companies do
  desc "compute pricing_settings_count for companies"
  task :compute_pricing_settings_count do
    ORM::Company.find_in_batches.with_index do |group, batch|
      puts "Processing group ##{batch}"
      group.each do |company|
        company.update_column(:pricing_settings_count, company.pricing_settings.count)
      end
    end
  end

  task :compute_pricing_settings_count_subquery do
    count_sql = ORM::Company
      .select("count(id)")
      .from("pricing_settings")
      .where("pricing_settings.company_code = companies.code")
      .to_sql
    records_updated = ORM::Company.
      update_all("pricing_settings_count = (#{count_sql})")

    puts "`#{records_updated}` companies have been updated"
  end
end
