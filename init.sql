
USE no78_mall_db;

-- 管理员用户表
CREATE TABLE IF NOT EXISTS tb_mall_admin_user (
    admin_user_id INT PRIMARY KEY AUTO_INCREMENT,
    login_user_name VARCHAR(50) NOT NULL,
    login_password VARCHAR(50) NOT NULL,
    nick_name VARCHAR(50),
    locked TINYINT DEFAULT 0
);

-- 商城用户表
CREATE TABLE IF NOT EXISTS tb_mall_user (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    nick_name VARCHAR(50),
    login_name VARCHAR(50) NOT NULL,
    password_md5 VARCHAR(50) NOT NULL,
    introduce_sign VARCHAR(200),
    address VARCHAR(200),
    is_deleted TINYINT DEFAULT 0,
    locked_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 商品分类表
CREATE TABLE IF NOT EXISTS tb_mall_goods_category (
    category_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_level TINYINT NOT NULL,
    parent_id BIGINT,
    category_name VARCHAR(50) NOT NULL,
    category_rank INT DEFAULT 0,
    is_deleted TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_user INT,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_user INT
);

-- 商品表
CREATE TABLE IF NOT EXISTS tb_mall_goods_info (
    goods_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    goods_name VARCHAR(200) NOT NULL,
    goods_intro VARCHAR(500),
    goods_category_id BIGINT,
    goods_cover_img VARCHAR(500),
    goods_carousel VARCHAR(500),
    original_price INT,
    selling_price INT,
    stock_num INT DEFAULT 0,
    tag VARCHAR(50),
    goods_sell_status TINYINT DEFAULT 0,
    create_user INT,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_user INT,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    goods_detail_content TEXT
);

-- 购物车表
CREATE TABLE IF NOT EXISTS tb_mall_shopping_cart_item (
    cart_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    goods_id BIGINT NOT NULL,
    goods_count INT DEFAULT 1,
    is_deleted TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 订单表
CREATE TABLE IF NOT EXISTS tb_mall_order (
    order_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_no VARCHAR(50) NOT NULL,
    user_id BIGINT NOT NULL,
    total_price INT,
    pay_status TINYINT DEFAULT 0,
    pay_type TINYINT DEFAULT 0,
    pay_time DATETIME,
    order_status TINYINT DEFAULT 0,
    extra_info VARCHAR(500),
    user_address VARCHAR(200),
    is_deleted TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 订单项表
CREATE TABLE IF NOT EXISTS tb_mall_order_item (
    order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    order_id BIGINT NOT NULL,
    goods_id BIGINT NOT NULL,
    goods_name VARCHAR(200),
    goods_cover_img VARCHAR(500),
    selling_price INT,
    goods_count INT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 轮播图表
CREATE TABLE IF NOT EXISTS tb_mall_carousel (
    carousel_id INT PRIMARY KEY AUTO_INCREMENT,
    carousel_url VARCHAR(500),
    redirect_url VARCHAR(500),
    carousel_rank INT DEFAULT 0,
    is_deleted TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_user INT,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_user INT
);

-- 首页配置表
CREATE TABLE IF NOT EXISTS tb_mall_index_config (
    config_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    config_name VARCHAR(50),
    config_type TINYINT,
    goods_id BIGINT,
    redirect_url VARCHAR(500),
    config_rank INT DEFAULT 0,
    is_deleted TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    create_user INT,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_user INT
);

-- 插入测试数据
INSERT INTO tb_mall_admin_user (login_user_name, login_password, nick_name) VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', '管理员');
INSERT INTO tb_mall_user (login_name, password_md5, nick_name, address) VALUES ('test', 'e10adc3949ba59abbe56e057f20f883e', '测试用户', '广东省深圳市');
INSERT INTO tb_mall_goods_category (category_level, parent_id, category_name, category_rank) VALUES
(1, 0, '手机数码', 1), (1, 0, '电脑办公', 2), (1, 0, '服装鞋帽', 3),
(2, 1, '智能手机', 1), (2, 1, '手机配件', 2), (2, 2, '笔记本电脑', 1), (2, 2, '台式机', 2),
(3, 4, '5G手机', 1), (3, 4, '游戏手机', 2);
INSERT INTO tb_mall_goods_info (goods_name, goods_intro, goods_category_id, original_price, selling_price, stock_num, tag, goods_sell_status, goods_detail_content) VALUES
('iPhone 15 Pro', '苹果最新旗舰手机', 4, 8999, 7999, 100, '热销', 0, 'A17 Pro芯片，钛金属设计'),
('华为Mate 60 Pro', '华为旗舰手机', 4, 6999, 6499, 80, '新品', 0, '麒麟9000S芯片，卫星通话'),
('MacBook Pro 14', '苹果笔记本电脑', 6, 14999, 13999, 50, '推荐', 0, 'M3 Pro芯片，Liquid Retina XDR显示屏');
INSERT INTO tb_mall_carousel (carousel_url, redirect_url, carousel_rank) VALUES
('/static/img/banner1.jpg', '/goods/1', 1),
('/static/img/banner2.jpg', '/goods/2', 2);
INSERT INTO tb_mall_index_config (config_name, config_type, goods_id, config_rank) VALUES
('热销商品', 3, 1, 1), ('新品上线', 4, 2, 2), ('为你推荐', 5, 3, 3);
