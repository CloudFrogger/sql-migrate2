-- +migrate Up
create table orders_results.configuration_scope_definition
(
    scope       varchar   not null primary key,
    description varchar   not null default 'some default description',
    created     timestamp not null default now()
);

insert into orders_results.configuration_scope_definition(scope, description)
values ('GLOBAL', 'Global configuration for orders-results');
insert into orders_results.configuration_scope_definition(scope, description)
values ('FACILITY', 'Overriding global configuration with customer-facility');

create table orders_results.configuration_key_definition
(
    configkey   varchar   not null primary key,
    description varchar   not null default '',
    created     timestamp not null default now()
);

insert into orders_results.configuration_key_definition (configkey, description)
values ('default_labreport_template_id', 'Default template id for generating / printing labReports');

create table orders_results.configuration
(
    uuid                 uuid      NOT NULL PRIMARY KEY DEFAULT uuid_generate_v4(),
    scope                varchar   not null references orders_results.configuration_scope_definition (scope),
    customer_facility_id uuid      not null             default '00000000-0000-0000-0000-000000000000',
    configkey            varchar   not null references orders_results.configuration_key_definition (configkey),
    value                varchar   not null             default '',
    created              timestamp not null             default now(),
    modified             timestamp not null             default now(),
    constraint unique_configurations unique (scope, customer_facility_id, configkey)
);

-- config the tool itself

insert into orders_results.configuration (scope, configkey, value)
values ('GLOBAL', 'default_labreport_template_id', '00000000-0000-0000-0000-000000000000');

-- +migrate Down
drop table orders_results.configuration;
drop table orders_results.configuration_key_definition;
drop table orders_results.configuration_scope_definition;