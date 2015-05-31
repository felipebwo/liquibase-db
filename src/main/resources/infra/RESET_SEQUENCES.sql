begin

  FOR r IN (select sid, serial#
              from v$session
             where sid in (select session_id
                             from v$locked_object
                            where oracle_username = user)) LOOP
    EXECUTE IMMEDIATE 'alter system kill session ''' || r.sid || ',' ||
                      r.serial# || '''';
  END LOOP;

  for rs in (select sequence_name from user_sequences) loop
      BEGIN
        execute immediate ('Drop sequence ' || rs.sequence_name);
        execute immediate ('Create sequence ' || rs.sequence_name ||
                          ' start with 1 nocache order');
      END;
  end loop;

end;
