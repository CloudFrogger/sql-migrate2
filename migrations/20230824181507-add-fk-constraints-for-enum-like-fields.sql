
-- +migrate Up
CREATE TABLE orders_results.http_request_directions (
	direction varchar NOT NULL,
	CONSTRAINT http_request_directions_pk PRIMARY KEY (direction)
);

INSERT INTO orders_results.http_request_directions (direction) VALUES
	 ('IN'),
	 ('OUT');

ALTER TABLE orders_results.http_request_log
ADD CONSTRAINT fk_http_request_directions FOREIGN KEY(direction) REFERENCES orders_results.http_request_directions(direction);


CREATE TABLE orders_results.interface_directions (
	direction varchar NOT NULL,
	CONSTRAINT interface_directions_pk PRIMARY KEY (direction)
);

INSERT INTO orders_results.interface_directions (direction) VALUES
	 ('OCA'),
	 ('EIA'),
	 ('UI');

ALTER TABLE orders_results.http_request_log
ADD CONSTRAINT fk_interface_directions FOREIGN KEY(interface_direction) REFERENCES orders_results.interface_directions(direction);


CREATE TABLE orders_results.ordered_examination_analyte_status_types (
	"type" varchar NOT NULL,
	CONSTRAINT ordered_examination_analyte_status_types_pk PRIMARY KEY ("type")
);

INSERT INTO orders_results.ordered_examination_analyte_status_types ("type") VALUES
	 ('initial'),
	 ('partialprocessing'),
	 ('processing'),
	 ('validation'),
	 ('finished'),
	 ('cancelled');

ALTER TABLE orders_results.ordered_examination_analytes
ADD CONSTRAINT fk_ordered_examination_analyte_status_types FOREIGN KEY(status) REFERENCES orders_results.ordered_examination_analyte_status_types(type);


CREATE TABLE orders_results.order_status_types (
	"type" varchar NOT NULL,
	CONSTRAINT order_status_types_pk PRIMARY KEY ("type")
);

INSERT INTO orders_results.order_status_types ("type") VALUES
	 ('FINALIZED'),
	 ('ENTERED'),
	 ('PROCESSING'),
	 ('ERROR_ENTERED'),
	 ('COMPLETED'),
	 ('DELETE_REQUESTED'),
	 ('DELETED');

ALTER TABLE orders_results.orders
ADD CONSTRAINT fk_order_status_types FOREIGN KEY(status) REFERENCES orders_results.order_status_types(type);
ALTER TABLE orders_results.orders_history
ADD CONSTRAINT fk_order_status_types FOREIGN KEY(order_status) REFERENCES orders_results.order_status_types(type);

CREATE TABLE orders_results.order_types (
	"type" varchar NOT NULL,
	CONSTRAINT order_types_pk PRIMARY KEY ("type")
);

INSERT INTO orders_results.order_types ("type") VALUES
	 ('DONOR'),
	 ('PERSONAL'),
	 ('PSEUDONYMIZED');

ALTER TABLE orders_results.orders
ADD CONSTRAINT fk_order_types FOREIGN KEY(order_type) REFERENCES orders_results.order_types(type);
ALTER TABLE orders_results.subjects
ADD CONSTRAINT fk_order_types FOREIGN KEY(subject_type) REFERENCES orders_results.order_types(type);


CREATE TABLE orders_results.order_donation_types (
	"type" varchar NOT NULL,
	description varchar NOT NULL,
	CONSTRAINT order_donation_types_pk PRIMARY KEY ("type")
);

INSERT INTO orders_results.order_donation_types ("type",description) VALUES
	 ('E','First time donor'),
	 ('2','Second time donor'),
	 ('M','Multiple times donor');

ALTER TABLE orders_results.orders_blood_donor_details
ADD CONSTRAINT fk_order_donation_types FOREIGN KEY(donation_type) REFERENCES orders_results.order_donation_types(type);


CREATE TABLE orders_results.prior_result_source_types (
	"type" varchar NOT NULL,
	description varchar NOT NULL,
	CONSTRAINT prior_result_source_types_pk PRIMARY KEY ("type")
);

INSERT INTO orders_results.prior_result_source_types ("type",description) VALUES
	 ('M','Manual entry'),
	 ('E','External');

ALTER TABLE orders_results.orders_blood_donor_details
ADD CONSTRAINT fk_orders_blood_donor_details FOREIGN KEY(source) REFERENCES orders_results.prior_result_source_types(type);


ALTER TABLE orders_results.result_status_types ADD CONSTRAINT result_status_types_un UNIQUE ("name");

ALTER TABLE orders_results.results
ADD CONSTRAINT fk_result_status_types FOREIGN KEY(status_type) REFERENCES orders_results.result_status_types(name);

-- +migrate Down
ALTER TABLE orders_results.http_request_log DROP CONSTRAINT fk_http_request_directions;
DROP TABLE orders_results.http_request_directions;

ALTER TABLE orders_results.http_request_log DROP CONSTRAINT fk_interface_directions;
DROP TABLE orders_results.interface_directions;

ALTER TABLE orders_results.ordered_examination_analytes DROP CONSTRAINT fk_ordered_examination_analyte_status_types;
DROP TABLE orders_results.ordered_examination_analyte_status_types;

ALTER TABLE orders_results.orders DROP CONSTRAINT fk_order_status_types;
ALTER TABLE orders_results.orders_history DROP CONSTRAINT fk_order_status_types;
DROP TABLE orders_results.order_status_types;

ALTER TABLE orders_results.orders DROP CONSTRAINT fk_order_types;
ALTER TABLE orders_results.subjects DROP CONSTRAINT fk_order_types;
DROP TABLE orders_results.order_types;

ALTER TABLE orders_results.orders_blood_donor_details DROP CONSTRAINT fk_order_donation_types;
DROP TABLE orders_results.order_donation_types;

ALTER TABLE orders_results.orders_blood_donor_details DROP CONSTRAINT fk_orders_blood_donor_details;
DROP TABLE orders_results.prior_result_source_types;

ALTER TABLE orders_results.results DROP CONSTRAINT fk_result_status_types;
ALTER TABLE orders_results.result_status_types DROP CONSTRAINT result_status_types_un;