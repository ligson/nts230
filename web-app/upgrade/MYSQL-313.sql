-- program
ALTER TABLE program MODIFY class_lib_id BIGINT(20) NULL;
ALTER TABLE program MODIFY directory_id BIGINT(20) NULL;

-- program_category_programs
DROP TABLE IF EXISTS `program_category_programs`;
CREATE TABLE program_category_programs (program_category_id BIGINT NOT NULL, program_id BIGINT NOT NULL, PRIMARY KEY (program_category_id, program_id), FOREIGN KEY (program_category_id) REFERENCES program_category (id), FOREIGN KEY (program_id) REFERENCES program (id))ENGINE =MyISAM DEFAULT CHARSET =utf8;
INSERT INTO program_category_programs (program_id, program_category_id) SELECT id, program_category_id FROM program WHERE program_category_id IN (SELECT id FROM program_category);
