CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT,
    name VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    date_of_birth DATE,
    balance INT,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

INSERT INTO users (name, phone, email, date_of_birth, balance) VALUES 
 ('Alice Johnson', '123-456-7890', 'alice.johnson@email.com', '1985-01-15', 100),
 ('Bob Smith', '234-567-8901', 'bob.smith@email.com', '1990-02-20', 200),
 ('Carol White', '345-678-9012', 'carol.white@email.com', '1992-03-25', 350),
 ('David Brown', '456-789-0123', 'david.brown@email.com', '1988-04-30', 123),
 ('Eva Green', '567-890-1234', 'eva.green@email.com', '1995-05-05', 650),
 ('Frank Moore', '678-901-2345', 'frank.moore@email.com', '1987-06-10', 10),
 ('Grace Lee', '789-012-3456', 'grace.lee@email.com', '1993-07-15', 324),
 ('Henry Wilson', '890-123-4567', 'henry.wilson@email.com', '1991-08-20', 333),
 ('Ivy Harris', '901-234-5678', 'ivy.harris@email.com', '1986-09-25', 444),
 ('Jack Martin', '012-345-6789', 'jack.martin@email.com', '1994-10-30', 400);


SET autocommit=0;
SET GLOBAL innodb_status_output=ON;
SET GLOBAL innodb_status_output_locks=ON;