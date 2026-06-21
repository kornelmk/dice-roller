CREATE TABLE dice_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    sides INTEGER NOT NULL
);

INSERT INTO dice_types(name, sides)
VALUES
('K4',4),
('K6',6),
('K8',8),
('K10',10),
('K12',12),
('K20',20),
('K100',100);