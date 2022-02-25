-- Usage
--   hive -f create_test_table.hql --database wmf_product

DROP TABLE IF EXISTS `test`;

CREATE TABLE `test` (
    `wiki_db`  string  COMMENT 'Database code',
    `year`     int,
    `month`    int,
    `day`      int,
    `hour`     int,
    `user`     string  COMMENT 'User executing the process'
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ","
STORED AS TEXTFILE
