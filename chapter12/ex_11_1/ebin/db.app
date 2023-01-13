{application, db,
   [{description, "Database"},
    {vsn, "1.0.0"},
    {modules, [db, db_gen, db_supervisor, db_app]},
    {registered, [db, db_supervisor]},
    {applications, [kernel, stdlib]},
    {env, []},
    {mod, {db_app,[]}}]}.
