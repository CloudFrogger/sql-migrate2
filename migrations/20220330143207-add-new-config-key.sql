
-- +migrate Up
insert into orders_results.configuration_key_definition (configkey, description)
values ('default_labreport_template_email_key', 'Default Email template key for sending emails');
-- +migrate Down
delete from orders_results.configuration_key_definition
where configkey = 'default_labreport_template_email_key' and description = 'Default Email template key for sending emails';