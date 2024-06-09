# sql-migrate

> SQL Schema migration tool for [Go](https://golang.org/). Inspired by [rubenv/sql-migrate](https://github.com/rubenv/sql-migrate) 

## Features

- Use as CLI tool 
- Supports SQLite, PostgreSQL, MySQL, MSSQL and Oracle databases 
- Atomic migrations
- Up/down migrations to allow rollback

## Installation

To install the command line program, use the following:

```bash
go install github.com/rubenv/sql-migrate/...@latest
```

## Usage

```
$ sql-migrate --help
usage: sql-migrate [--version] [--help] <command> [<args>]

Available commands are:
    down      Undo a database migration
    new       Create a new migration
    redo      Reapply the last migration
    status    Show migration status
    up        Migrates the database to the most recent version available
```

Each command requires a configuration file (which defaults to `dbconfig.yml`, but can be specified with the `-config` flag). This config file should specify one or more environments:

```yml
config:
  dialect: postgres
  datasource: dbname=myapp sslmode=disable
  dir: migrations
  table: migrations
```

Also one can obtain env variables in datasource field :

```yml
config:
  dialect: postgres
  datasource: host=prodhost dbname=proddb user=${DB_USER} password=${DB_PASSWORD} sslmode=require
  dir: migrations
  table: migrations
```

The `table` setting is optional and will default to `migrations`.

Use the `--help` flag in combination with any of the commands to get an overview of its usage:

```
$ sql-migrate up --help
Usage: sql-migrate up [options] ...

  Migrates the database to the most recent version available.

Options:

  -config=dbconfig.yml   Configuration file to use.
  -limit=0               Limit the number of migrations (0 = unlimited).
  -dryrun                Don't apply migrations, just print them.
```

The `new` command creates a new empty migration template using the following pattern `<current time>-<name>.sql`.

The `up` command applies all available migrations. By contrast, `down` will only apply one migration by default. 

The `redo` command will unapply the last migration and reapply it. This is useful during development, when you're writing migrations.

Use the `status` command to see the state of the applied migrations:

```bash
$ sql-migrate status
+---------------+-----------------------------------------+
|   MIGRATION   |                 APPLIED                 |
+---------------+-----------------------------------------+
| 1_initial.sql | 2024-12-13 08:19:06.788354925 +0000 UTC |
| 2_record.sql  | no                                      |
+---------------+-----------------------------------------+
```

### Postgres
Postgres Driver is [pgx](github.com/jackc/pgx/v4)
```yml
config:
  dialect: postgres
  datasource: host=${DB_SERVER} dbname=${DB_DATABASE} user=${DB_USER} password=${DB_PASS} port=${DB_PORT} sslmode=${DB_SSL_MODE}
  dir: migrations
  table: schema1
```

### Yugabyte

(not implemented yet)


Yugabyte Driver is [unkown](hope we will be good)

### MySQL 

(not implemented yet)

If you are using MySQL, you must append `?parseTime=true` to the `datasource` configuration. For example:

```yml
config:
  dialect: mysql
  datasource: root@/dbname?parseTime=true
  dir: migrations/mysql
  table: migrations
```

See [here](https://github.com/go-sql-driver/mysql#parsetime) for more information.

### Oracle (godror)

(not implemented yet)

Oracle Driver is [godror](https://github.com/godror/godror), it is not pure Go code and relies on Oracle Office Client ([Instant Client](https://www.oracle.com/database/technologies/instant-client/downloads.html)), more detailed information is in the [godror repository](https://github.com/godror/godror).

## Credits
This is fanware for the outstanding work of rubenv. I dont like gorm and I wanted yugabyte in the game so I was forced to write my own. 
Also I didnt like the staging support, in my opinon that is still too much complexity, so I removed all of that.