
ActiveRecord::Base.connection.execute <<~SQL
  insert into jobs (scheduled_for) SELECT now() FROM generate_series(1,10000);
SQL
