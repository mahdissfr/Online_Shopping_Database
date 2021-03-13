-- phpMyAdmin SQL Dump
-- version 4.8.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 20, 2019 at 11:11 PM
-- Server version: 10.1.32-MariaDB
-- PHP Version: 5.6.36

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fproject`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` char(5) NOT NULL,
  `name` varchar(15) NOT NULL,
  `fname` varchar(20) NOT NULL,
  `phone_number` varchar(11) NOT NULL,
  `address` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`, `name`, `fname`, `phone_number`, `address`) VALUES
('00001', 'arad', 'arab', '09116665431', 'tehran ferdowsi'),
('00002', 'amin', 'sharif', '09108854342', 'tabriz sa\'adat abad'),
('00003', 'simin', 'omrani', '09017656543', 'shiraz sadi st');

-- --------------------------------------------------------

--
-- Table structure for table `agent`
--

CREATE TABLE `agent` (
  `agent_id` char(5) NOT NULL,
  `name` varchar(15) NOT NULL,
  `fname` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `agent`
--

INSERT INTO `agent` (`agent_id`, `name`, `fname`) VALUES
('00001', 'saba', 'arab'),
('00002', 'ali', 'rad'),
('00003', 'nasim', 'hosseini');

-- --------------------------------------------------------

--
-- Table structure for table `charge`
--

CREATE TABLE `charge` (
  `customer_id` char(5) NOT NULL,
  `amount` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Triggers `charge`
--
DELIMITER $$
CREATE TRIGGER `charge_credit` AFTER INSERT ON `charge` FOR EACH ROW BEGIN
	update customer 
    	set credit = credit + new.amount
     where id = new.customer_id;
    	
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id` char(5) NOT NULL,
  `pass` varchar(8) NOT NULL,
  `email` varchar(40) NOT NULL,
  `name` varchar(15) NOT NULL,
  `fname` varchar(20) NOT NULL,
  `sex` set('female','male') NOT NULL,
  `credit` float NOT NULL,
  `registered` set('yes','no') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id`, `pass`, `email`, `name`, `fname`, `sex`, `credit`, `registered`) VALUES
('00001', '77667766', 'ali@gmail.com', 'ali', 'alavi', 'male', 5999580, 'yes'),
('00002', '89898989', 'anil@gmail.com', 'anil', 'safari', 'female', 8999440, 'yes'),
('00003', '10101010', 'amir@gmail.com', 'amir', 'mobini', 'male', 5000000, 'yes'),
('00004', '24242424', 'maral@gmail.com', 'maral', 'azimi', 'female', 8997470, 'yes'),
('00005', 'e70f267e', 'mina@gmail.com', 'mina', 'alavi', 'female', 0, 'yes'),
('00006', '--------', 'soha@gmail.com', 'soha', 'asadi', 'female', 0, 'no');

--
-- Triggers `customer`
--
DELIMITER $$
CREATE TRIGGER `controller` BEFORE INSERT ON `customer` FOR EACH ROW BEGIN
  IF LENGTH(NEW.pass) != 64 THEN
    SET NEW.pass = SHA2(NEW.pass,0);
  END IF;
  IF new.registered = 'no' THEN
    SET NEW.pass = '--------',new.credit = 0;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_customerlog` AFTER UPDATE ON `customer` FOR EACH ROW BEGIN
	insert into customer_log values(OLD.id,new.credit,now(),old.credit);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_id_pc`
--

CREATE TABLE `customer_id_pc` (
  `id` char(5) NOT NULL,
  `address` varchar(100) NOT NULL,
  `postal_code` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer_id_pc`
--

INSERT INTO `customer_id_pc` (`id`, `address`, `postal_code`) VALUES
('00001', 'tehran vali asr st', '7578387788'),
('00001', 'tehran vanak sqr', '4254652231'),
('00002', 'tabriz azadi st', '8876543435'),
('00002', 'tabriz shademan st', '1000765223'),
('00003', 'isfahan imam st', '7765443432'),
('00003', 'isfahan azadi sqr', '8844537725'),
('00004', 'shiraz sadi st', '7755331412'),
('00004', 'shiraz hafez st', '4545332328'),
('00005', 'tehran rasht st', '1035765223'),
('00006', 'tehran tehran pars', '4252342231');

-- --------------------------------------------------------

--
-- Table structure for table `customer_log`
--

CREATE TABLE `customer_log` (
  `id` char(5) NOT NULL,
  `credit` float NOT NULL,
  `cdate` datetime NOT NULL,
  `xcredit` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer_log`
--

INSERT INTO `customer_log` (`id`, `credit`, `cdate`, `xcredit`) VALUES
('00001', 5999710, '2019-01-20 21:15:48', 6000000),
('00001', 5999580, '2019-01-20 21:24:52', 5999710),
('00005', 0, '2019-01-20 21:25:27', 5000000),
('00005', -320, '2019-01-20 21:26:40', 0),
('00005', 0, '2019-01-20 21:31:03', -320),
('00001', 6000290, '2019-01-20 22:37:52', 5999580),
('00002', 8999820, '2019-01-20 22:38:35', 9000000),
('00002', 8999630, '2019-01-20 22:38:48', 8999820),
('00002', 8999440, '2019-01-20 22:39:00', 8999630),
('00001', 6000160, '2019-01-20 22:52:37', 6000290),
('00001', 5999870, '2019-01-20 22:53:11', 6000160),
('00001', 5999580, '2019-01-20 22:53:21', 5999870),
('00004', 8999050, '2019-01-20 22:54:50', 9000000),
('00004', 8998260, '2019-01-20 22:54:59', 8999050),
('00004', 8997470, '2019-01-20 22:55:08', 8998260);

-- --------------------------------------------------------

--
-- Table structure for table `customer_pn`
--

CREATE TABLE `customer_pn` (
  `id` char(5) NOT NULL,
  `phone_number` varchar(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `customer_pn`
--

INSERT INTO `customer_pn` (`id`, `phone_number`) VALUES
('00001', '09107776655'),
('00001', '09108877877'),
('00004', '09033338787'),
('00004', '09398876655'),
('00002', '09104453321'),
('00002', '09366675454'),
('00003', '09217674453'),
('00003', '09108875564'),
('00002', '09031506333');

-- --------------------------------------------------------

--
-- Table structure for table `delivery`
--

CREATE TABLE `delivery` (
  `delivery_id` char(5) NOT NULL,
  `name` varchar(15) NOT NULL,
  `fname` varchar(20) NOT NULL,
  `phone_number` varchar(11) NOT NULL,
  `statuss` set('free','sending') NOT NULL,
  `order_id` char(5) NOT NULL DEFAULT '-----',
  `current_order_cost` float NOT NULL DEFAULT '0',
  `credit` float NOT NULL,
  `order_rate` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `delivery`
--

INSERT INTO `delivery` (`delivery_id`, `name`, `fname`, `phone_number`, `statuss`, `order_id`, `current_order_cost`, `credit`, `order_rate`) VALUES
('00001', 'alireza', 'sadri', '09110000122', 'free', '-----', 0, 0, 0),
('00002', 'shariar', 'misaqi', '09108887765', 'sending', '00006', 290, 14.5, 1),
('00003', 'iman', 'asadi', '09398887676', 'sending', '00002', 560, 28, 1),
('00004', 'milad', 'amini', '09138887543', 'sending', '00003', 2530, 126.5, 1),
('00005', 'omid', 'balavar', '01277765650', 'sending', '00005', 710, 35.5, 1),
('00006', 'danial', 'khosravi', '09366647342', 'free', '-----', 0, 0, 0);

--
-- Triggers `delivery`
--
DELIMITER $$
CREATE TRIGGER `update_delivery_log` AFTER UPDATE ON `delivery` FOR EACH ROW BEGIN
	insert into delivery_log values(OLD.delivery_id,NEW.credit,NEW.statuss,now(),OLD.credit,OLD.statuss);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `delivery_log`
--

CREATE TABLE `delivery_log` (
  `delivery_id` char(5) NOT NULL,
  `credit` float NOT NULL,
  `statuss` set('free','sending') NOT NULL,
  `cdate` datetime NOT NULL,
  `xcredit` float NOT NULL,
  `xstatus` set('free','sending') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `delivery_log`
--

INSERT INTO `delivery_log` (`delivery_id`, `credit`, `statuss`, `cdate`, `xcredit`, `xstatus`) VALUES
('00005', 14.5, 'sending', '2019-01-20 21:15:48', 0, 'free'),
('00005', 21, 'sending', '2019-01-20 21:24:52', 14.5, 'sending'),
('00004', 16, 'sending', '2019-01-20 21:26:40', 0, 'free'),
('00004', 16, 'free', '2019-01-20 21:31:35', 16, 'sending'),
('00004', 16, 'free', '2019-01-20 21:31:40', 16, 'free'),
('00004', 16, 'free', '2019-01-20 21:31:43', 16, 'free'),
('00004', 0, 'free', '2019-01-20 21:31:46', 16, 'free'),
('00004', 0, 'free', '2019-01-20 21:31:49', 0, 'free'),
('00005', 21, 'free', '2019-01-20 22:37:52', 21, 'sending'),
('00005', 0, 'free', '2019-01-20 22:37:52', 21, 'free'),
('00003', 9, 'sending', '2019-01-20 22:38:35', 0, 'free'),
('00003', 18.5, 'sending', '2019-01-20 22:38:48', 9, 'sending'),
('00003', 28, 'sending', '2019-01-20 22:39:00', 18.5, 'sending'),
('00003', 28, 'free', '2019-01-20 22:41:56', 28, 'sending'),
('00003', 28, 'sending', '2019-01-20 22:42:37', 28, 'free'),
('00003', 28, 'sending', '2019-01-20 22:42:47', 28, 'sending'),
('00005', 6.5, 'sending', '2019-01-20 22:52:37', 0, 'free'),
('00005', 21, 'sending', '2019-01-20 22:53:11', 6.5, 'sending'),
('00005', 35.5, 'sending', '2019-01-20 22:53:21', 21, 'sending'),
('00004', 47.5, 'sending', '2019-01-20 22:54:50', 0, 'free'),
('00004', 87, 'sending', '2019-01-20 22:54:59', 47.5, 'sending'),
('00004', 126.5, 'sending', '2019-01-20 22:55:08', 87, 'sending'),
('00002', 14.5, 'sending', '2019-01-20 22:58:14', 0, 'free');

-- --------------------------------------------------------

--
-- Table structure for table `failed_log`
--

CREATE TABLE `failed_log` (
  `customer_id` char(5) NOT NULL,
  `failed_reason` varchar(100) NOT NULL,
  `admin_id` char(5) NOT NULL,
  `cdate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `failed_log`
--

INSERT INTO `failed_log` (`customer_id`, `failed_reason`, `admin_id`, `cdate`) VALUES
('00005', 'no enough credit', '00002', '2019-01-20 21:32:04'),
('00001', 'product was not valid in the store', '00003', '2019-01-20 22:37:52'),
('00001', 'store was closed', '00003', '2019-01-20 22:50:04'),
('00006', 'store was closed', '00001', '2019-01-20 22:56:40');

-- --------------------------------------------------------

--
-- Table structure for table `ordered_products`
--

CREATE TABLE `ordered_products` (
  `order_id` char(5) NOT NULL,
  `product_id` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ordered_products`
--

INSERT INTO `ordered_products` (`order_id`, `product_id`) VALUES
('00001', '00001'),
('00001', '00006'),
('00004', '00003'),
('00004', '00003'),
('00001', '00001'),
('00002', '00005'),
('00002', '00008'),
('00002', '00008'),
('00005', '00006'),
('00005', '00001'),
('00005', '00001'),
('00003', '00010'),
('00003', '00011'),
('00003', '00011'),
('00006', '00001');

--
-- Triggers `ordered_products`
--
DELIMITER $$
CREATE TRIGGER `finsertion_check` AFTER INSERT ON `ordered_products` FOR EACH ROW BEGIN
set 
	@sid := (SELECT store_id
            FROM orders
            where order_id = new.order_id);
         
         
CREATE TEMPORARY TABLE valid_products
        select sp.product_id as pid
        from `store's_products` as sp
        where sp.store_id = @sid and sp.amount <> 0;
        
CREATE TEMPORARY TABLE deliveries
        select sd.delivery_id as did
        from delivery natural join `store's_deliveries` as sd
        where sd.store_id = @sid and delivery.statuss = 'free';
        
CREATE TEMPORARY TABLE admins
        select sa.admin_id as aid
        from `store's_admins` as sa
        where sa.store_id = @sid ;
        
CREATE TEMPORARY TABLE last_products
        select product_id
        from ordered_products
        where order_id = new.order_id ;
 
set @new_delivery :=
		(SELECT did FROM deliveries LIMIT 1);
        
set @current_delivery :=
		(SELECT delivery_id FROM delivery where order_id = new.order_id);
 
set @admin :=
		(
        select aid
            from admins
            ORDER BY RAND()
			LIMIT 1
        );
 
set @fcost :=
        (select price - off
        from product
        where product_id = new.product_id);

SET
	@sta := (SELECT statuss
        from orders
        where order_id = new.order_id);
        
set @ccredit := (SELECT customer.credit
            FROM orders ,customer
            where orders.customer_id = customer.id and orders.order_id = new.order_id);
    
set @payment := (SELECT payment
        from orders
        where order_id = new.order_id );

set 
	@cid := (SELECT customer.id
            FROM orders ,customer
            where orders.customer_id = customer.id and orders.order_id = new.order_id);

set @ccost := (SELECT current_order_cost FROM delivery where order_id = new.order_id);



############bekhatere nabudane mahsul fail beshe
  IF @sta <> 'failed' and not EXISTS (  
    SELECT pid
        FROM valid_products
        WHERE new.product_id = pid) THEN
    
    
    insert into failed_log values(@cid,'product was not valid in the store',@admin,now());
    
    UPDATE orders
      SET statuss = 'failed'
      WHERE order_id = new.order_id;
      
      #########sefareshe aval nabashe
      if (@current_delivery IS NOT NULL) THEN
      
          UPDATE delivery
                  SET  credit = credit - 0.05*@ccost ,current_order_cost = 0 ,statuss ='free',order_rate = order_rate-1,order_id = '-----'
                  WHERE delivery_id = @current_delivery;
          end if;
 		  if @payment='credit' THEN         
            UPDATE customer
              SET credit = credit + (select sum(price-off) 
                                     from product natural join last_products
                                    )
              WHERE id = @cid;
			end if;
           UPDATE `store's_products`
              SET amount = amount + 1,order_rate = order_rate - 1
              WHERE product_id in (select product_id from last_products);

 
  ###################peyk nis
	ELSEIF @sta <> 'failed' and (@current_delivery IS NULL) and not EXISTS (SELECT did FROM deliveries) THEN
  
  insert into failed_log values(@cid,'no free delivery',@admin,now());
  
    UPDATE orders
      SET statuss = 'failed'
      WHERE order_id = new.order_id;
 
   ####################mojudi nakafi
   
  ELSEIF (@sta <> 'failed') and (@ccredit < @fcost) and  (@payment='credit') THEN
      insert into failed_log values(@cid,'no enough credit',@admin,now());
    
    UPDATE orders
      SET statuss = 'failed'
      WHERE order_id = new.order_id;
      
      				#########sefareshe aval nabashe
      if (@current_delivery IS NOT NULL) THEN
      
          UPDATE delivery
                  SET  credit = credit - 0.05*@ccost,current_order_cost = 0 ,statuss ='free',order_rate = order_rate-1,order_id = '-----'
                  WHERE delivery_id = @current_delivery;
                       
                  
          UPDATE customer
              SET credit = credit + (select sum(price-off) 
                                     from product natural join last_products
                                    )
              WHERE id = @cid;
            
           UPDATE `store's_products`
              SET amount = amount + 1,order_rate = order_rate - 1
              WHERE product_id in (select product_id from last_products);
          end if;
      
      
  
   ################qarare sabt beshe   
  ELSEIF @sta <> 'failed' and ((@ccredit > @fcost) or (@payment='portal bank')) THEN
  
  	if  (@current_delivery IS NOT NULL) then
          UPDATE delivery
          SET credit = credit + 0.05*@fcost,current_order_cost = current_order_cost + @fcost
          WHERE delivery_id = @current_delivery;
    elseif  (@current_delivery IS NULL) then 
    
        UPDATE delivery
              SET statuss = 'sending',order_rate = order_rate+1,credit = 	credit + 0.05*@fcost ,order_id = new.order_id,current_order_cost = current_order_cost + @fcost
              WHERE delivery_id = @new_delivery;
      end if;
      
      if @payment='credit' THEN  
      UPDATE customer
      SET credit = credit - @fcost
      WHERE id = @cid;
      end if;
      
      UPDATE orders
              SET statuss = 'sending'
              WHERE order_id = new.order_id;
      
      
      UPDATE `store's_products`
      SET amount = amount - 1,order_rate = order_rate + 1
      WHERE product_id = new.product_id;
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` char(5) NOT NULL,
  `store_id` char(5) NOT NULL,
  `customer_id` char(5) NOT NULL,
  `statuss` set('submitted','sending','delivered','failed') NOT NULL DEFAULT 'submitted',
  `payment` set('credit','portal bank') NOT NULL DEFAULT 'portal bank',
  `date` date NOT NULL,
  `address` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `store_id`, `customer_id`, `statuss`, `payment`, `date`, `address`) VALUES
('00001', '00001', '00001', 'failed', 'credit', '2019-01-10', 'tehran vali asr st'),
('00002', '00002', '00002', 'sending', 'credit', '2019-01-10', 'tabriz shademan st'),
('00003', '00003', '00004', 'sending', 'credit', '2019-01-10', 'shiraz sadi st'),
('00004', '00003', '00005', 'failed', 'credit', '2019-01-24', 'tehran rasht st'),
('00005', '00001', '00001', 'sending', 'credit', '2019-01-16', 'tehran vali asr st'),
('00006', '00001', '00006', 'sending', 'portal bank', '2019-01-18', 'esfahan imam sqr');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `order_failure` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN

	CREATE TEMPORARY TABLE caddress
        select address
        from `customer_id_pc` as sa
        where id = new.customer_id ;
        
    CREATE TEMPORARY TABLE admins
        select sa.admin_id as aid
        from `store's_admins` as sa
        where sa.store_id = new.store_id ;
 
	set @admin :=
		(
        select aid
            from admins
            ORDER BY RAND()
			LIMIT 1
        ); 
 
    set 
      @ctime := CURRENT_TIME();
      
    set
      @t_open := (select t_open
        from store
        where store_id = new.store_id);
        
    set
      @t_close := (select t_close
        from store
        where store_id = new.store_id);
        
    set
      @reg := (select registered
        from customer
        where id = new.customer_id);
        
    
    
        
    #########tuye zamane forushgah has ya na
  	IF @ctime > @t_close or @ctime < @t_open THEN
    	insert into failed_log values(new.customer_id,'store was closed',@admin,now());
    	SET NEW.statuss = 'failed';
     end if;
     ########age register nis default portal bank
    if @reg = 'no' THEN
    	SET NEW.payment =  'portal bank';
       ########age register has addresso check kone  
    ELSEIF not exists(select address
                     from caddress
                     where address = new.address) THEN
         insert into failed_log values(new.customer_id,'wrong address',@admin,now());
    	SET NEW.statuss = 'failed';
                     
  	END IF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_orderlog_delivery_check` AFTER UPDATE ON `orders` FOR EACH ROW BEGIN
	insert into orders_log values(OLD.order_id,new.statuss,now(),old.statuss);

	UPDATE delivery
      SET statuss = 'free',order_id = '-----'
      WHERE order_id = new.order_id and statuss = 'delivered';

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `orders_log`
--

CREATE TABLE `orders_log` (
  `order_id` char(5) NOT NULL,
  `statuss` set('submitted','sending','delivered','failed') NOT NULL,
  `cdate` datetime NOT NULL,
  `xstatus` set('submitted','sending','delivered','failed') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orders_log`
--

INSERT INTO `orders_log` (`order_id`, `statuss`, `cdate`, `xstatus`) VALUES
('00002', 'submitted', '2019-01-20 21:10:09', 'submitted'),
('00004', '', '2019-01-20 21:32:04', 'submitted'),
('00004', 'submitted', '2019-01-20 22:33:27', ''),
('00004', 'failed', '2019-01-20 22:35:42', 'submitted'),
('00001', 'failed', '2019-01-20 22:37:52', 'submitted'),
('00002', 'sending', '2019-01-20 22:41:56', 'submitted'),
('00005', 'failed', '2019-01-20 22:50:17', 'failed'),
('00005', 'submitted', '2019-01-20 22:51:51', 'failed'),
('00005', 'sending', '2019-01-20 22:52:37', 'submitted'),
('00005', 'sending', '2019-01-20 22:53:11', 'sending'),
('00005', 'sending', '2019-01-20 22:53:21', 'sending'),
('00003', 'sending', '2019-01-20 22:54:50', 'submitted'),
('00003', 'sending', '2019-01-20 22:54:59', 'sending'),
('00003', 'sending', '2019-01-20 22:55:08', 'sending'),
('00006', 'failed', '2019-01-20 22:57:09', 'failed'),
('00006', 'submitted', '2019-01-20 22:57:14', 'failed'),
('00006', 'sending', '2019-01-20 22:58:14', 'submitted');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `product_id` char(5) NOT NULL,
  `product_title` varchar(15) NOT NULL,
  `store_id` char(5) NOT NULL,
  `price` int(8) NOT NULL,
  `off` int(8) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `product_title`, `store_id`, `price`, `off`) VALUES
('00001', 'red_shoe', '00001', 300, 10),
('00002', 'blue_hat', '00002', 200, 50),
('00003', 'black_skirt', '00003', 350, 30),
('00004', 'white_hat', '00002', 150, 10),
('00005', 'blue_shirt', '00002', 200, 20),
('00006', 'black_cap', '00001', 150, 20),
('00007', 'blue_skirt', '00001', 400, 30),
('00008', 'red_shirt', '00002', 230, 40),
('00009', 'grey_shoe', '00002', 400, 30),
('00010', 'blue_dress', '00003', 1000, 50),
('00011', 'long_dress', '00003', 800, 10),
('00012', 'orange_hat', '00003', 120, 10);

-- --------------------------------------------------------

--
-- Table structure for table `store`
--

CREATE TABLE `store` (
  `store_id` char(5) NOT NULL,
  `store_name` varchar(15) NOT NULL,
  `manager` varchar(15) DEFAULT NULL,
  `t_open` time NOT NULL,
  `t_close` time NOT NULL,
  `city` varchar(15) NOT NULL,
  `address` varchar(100) NOT NULL,
  `phone_number` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `store`
--

INSERT INTO `store` (`store_id`, `store_name`, `manager`, `t_open`, `t_close`, `city`, `address`, `phone_number`) VALUES
('00001', 'tommy', 'Mr karimi', '10:00:00', '23:59:00', 'tehran', 'Sattari Expy', '02177777777'),
('00002', 'gap', 'Mrs zarandi', '12:00:00', '21:00:00', 'tehran', 'Vanak sqr', '02133333333'),
('00003', 'zara', 'Mr rohbani', '04:00:00', '22:00:00', 'tehran', 'Sa\'dabad St', '02155555555');

-- --------------------------------------------------------

--
-- Table structure for table `store's_admins`
--

CREATE TABLE `store's_admins` (
  `store_id` char(5) NOT NULL,
  `admin_id` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `store's_admins`
--

INSERT INTO `store's_admins` (`store_id`, `admin_id`) VALUES
('00001', '00003'),
('00002', '00001'),
('00003', '00002');

-- --------------------------------------------------------

--
-- Table structure for table `store's_agents`
--

CREATE TABLE `store's_agents` (
  `store_id` char(5) NOT NULL,
  `agent_id` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `store's_agents`
--

INSERT INTO `store's_agents` (`store_id`, `agent_id`) VALUES
('00001', '00002'),
('00002', '00001'),
('00003', '00003');

-- --------------------------------------------------------

--
-- Table structure for table `store's_deliveries`
--

CREATE TABLE `store's_deliveries` (
  `store_id` char(5) NOT NULL,
  `delivery_id` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `store's_deliveries`
--

INSERT INTO `store's_deliveries` (`store_id`, `delivery_id`) VALUES
('00001', '00005'),
('00001', '00002'),
('00002', '00003'),
('00002', '00001'),
('00003', '00004'),
('00003', '00006');

-- --------------------------------------------------------

--
-- Table structure for table `store's_products`
--

CREATE TABLE `store's_products` (
  `store_id` char(5) NOT NULL,
  `product_id` char(5) NOT NULL,
  `amount` int(11) NOT NULL,
  `order_rate` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `store's_products`
--

INSERT INTO `store's_products` (`store_id`, `product_id`, `amount`, `order_rate`) VALUES
('00001', '00001', 0, 3),
('00002', '00002', 3, 0),
('00003', '00003', 3, 1),
('00002', '00004', 3, 0),
('00002', '00005', 2, 1),
('00001', '00006', 2, 1),
('00001', '00007', 3, 0),
('00002', '00008', 1, 2),
('00002', '00009', 3, 0),
('00003', '00010', 3, 1),
('00003', '00011', 2, 2),
('00003', '00012', 4, 0);

--
-- Triggers `store's_products`
--
DELIMITER $$
CREATE TRIGGER `update_sp_log` BEFORE UPDATE ON `store's_products` FOR EACH ROW BEGIN
	insert into `store's_products_log` values(OLD.store_id,OLD.product_id,new.amount,now(),old.amount);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `store's_products_log`
--

CREATE TABLE `store's_products_log` (
  `store_id` char(5) NOT NULL,
  `product_id` char(5) NOT NULL,
  `amount` int(11) NOT NULL,
  `cdate` datetime NOT NULL,
  `xamount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `store's_products_log`
--

INSERT INTO `store's_products_log` (`store_id`, `product_id`, `amount`, `cdate`, `xamount`) VALUES
('00001', '00001', 1, '2019-01-20 20:54:47', 1),
('00002', '00002', 1, '2019-01-20 20:54:47', 1),
('00003', '00003', 4, '2019-01-20 20:54:47', 4),
('00002', '00004', 3, '2019-01-20 20:54:47', 3),
('00002', '00005', 2, '2019-01-20 20:54:47', 2),
('00001', '00006', 0, '2019-01-20 20:54:47', 0),
('00001', '00007', 3, '2019-01-20 20:54:47', 3),
('00002', '00008', 3, '2019-01-20 20:54:47', 3),
('00002', '00009', 1, '2019-01-20 20:54:47', 1),
('00003', '00010', 1, '2019-01-20 20:54:47', 1),
('00003', '00011', 3, '2019-01-20 20:54:47', 3),
('00003', '00012', 0, '2019-01-20 20:54:47', 0),
('00001', '00001', 3, '2019-01-20 20:56:04', 1),
('00001', '00006', 3, '2019-01-20 20:56:04', 0),
('00001', '00007', 3, '2019-01-20 20:56:04', 3),
('00002', '00002', 3, '2019-01-20 20:56:21', 1),
('00002', '00004', 3, '2019-01-20 20:56:21', 3),
('00002', '00005', 3, '2019-01-20 20:56:21', 2),
('00002', '00008', 3, '2019-01-20 20:56:21', 3),
('00002', '00009', 3, '2019-01-20 20:56:21', 1),
('00003', '00003', 4, '2019-01-20 20:56:34', 4),
('00003', '00010', 4, '2019-01-20 20:56:34', 1),
('00003', '00011', 4, '2019-01-20 20:56:34', 3),
('00003', '00012', 4, '2019-01-20 20:56:34', 0),
('00001', '00001', 2, '2019-01-20 21:11:31', 3),
('00001', '00006', 2, '2019-01-20 21:11:43', 3),
('00001', '00001', 1, '2019-01-20 21:11:49', 2),
('00001', '00001', 0, '2019-01-20 21:15:48', 1),
('00001', '00006', 1, '2019-01-20 21:24:52', 2),
('00003', '00003', 3, '2019-01-20 21:26:40', 4),
('00001', '00001', 1, '2019-01-20 22:37:52', 0),
('00001', '00006', 2, '2019-01-20 22:37:52', 1),
('00002', '00005', 2, '2019-01-20 22:38:35', 3),
('00002', '00008', 2, '2019-01-20 22:38:48', 3),
('00002', '00008', 1, '2019-01-20 22:39:00', 2),
('00001', '00001', 3, '2019-01-20 22:49:19', 1),
('00001', '00006', 3, '2019-01-20 22:49:19', 2),
('00001', '00007', 3, '2019-01-20 22:49:19', 3),
('00001', '00006', 2, '2019-01-20 22:52:37', 3),
('00001', '00001', 2, '2019-01-20 22:53:11', 3),
('00001', '00001', 1, '2019-01-20 22:53:21', 2),
('00003', '00010', 3, '2019-01-20 22:54:50', 4),
('00003', '00011', 3, '2019-01-20 22:54:59', 4),
('00003', '00011', 2, '2019-01-20 22:55:08', 3),
('00001', '00001', 0, '2019-01-20 22:58:14', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `agent`
--
ALTER TABLE `agent`
  ADD PRIMARY KEY (`agent_id`);

--
-- Indexes for table `charge`
--
ALTER TABLE `charge`
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_id_pc`
--
ALTER TABLE `customer_id_pc`
  ADD KEY `id` (`id`);

--
-- Indexes for table `customer_pn`
--
ALTER TABLE `customer_pn`
  ADD KEY `id` (`id`);

--
-- Indexes for table `delivery`
--
ALTER TABLE `delivery`
  ADD PRIMARY KEY (`delivery_id`);

--
-- Indexes for table `ordered_products`
--
ALTER TABLE `ordered_products`
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `store_id` (`store_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `store`
--
ALTER TABLE `store`
  ADD PRIMARY KEY (`store_id`);

--
-- Indexes for table `store's_admins`
--
ALTER TABLE `store's_admins`
  ADD KEY `store_id` (`store_id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indexes for table `store's_agents`
--
ALTER TABLE `store's_agents`
  ADD KEY `store_id` (`store_id`),
  ADD KEY `agent_id` (`agent_id`);

--
-- Indexes for table `store's_deliveries`
--
ALTER TABLE `store's_deliveries`
  ADD KEY `store_id` (`store_id`),
  ADD KEY `delivery_id` (`delivery_id`);

--
-- Indexes for table `store's_products`
--
ALTER TABLE `store's_products`
  ADD KEY `product_id` (`product_id`),
  ADD KEY `store_id` (`store_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `charge`
--
ALTER TABLE `charge`
  ADD CONSTRAINT `charge_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`);

--
-- Constraints for table `customer_id_pc`
--
ALTER TABLE `customer_id_pc`
  ADD CONSTRAINT `customer_id_pc_ibfk_1` FOREIGN KEY (`id`) REFERENCES `customer` (`id`);

--
-- Constraints for table `customer_pn`
--
ALTER TABLE `customer_pn`
  ADD CONSTRAINT `customer_pn_ibfk_1` FOREIGN KEY (`id`) REFERENCES `customer` (`id`);

--
-- Constraints for table `ordered_products`
--
ALTER TABLE `ordered_products`
  ADD CONSTRAINT `ordered_products_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `ordered_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`),
  ADD CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`),
  ADD CONSTRAINT `orders_ibfk_4` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`);

--
-- Constraints for table `store's_admins`
--
ALTER TABLE `store's_admins`
  ADD CONSTRAINT `store's_admins_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`),
  ADD CONSTRAINT `store's_admins_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`),
  ADD CONSTRAINT `store's_admins_ibfk_3` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`);

--
-- Constraints for table `store's_agents`
--
ALTER TABLE `store's_agents`
  ADD CONSTRAINT `FK_storeid_agent` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`),
  ADD CONSTRAINT `store's_agents_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`),
  ADD CONSTRAINT `store's_agents_ibfk_2` FOREIGN KEY (`agent_id`) REFERENCES `agent` (`agent_id`);

--
-- Constraints for table `store's_deliveries`
--
ALTER TABLE `store's_deliveries`
  ADD CONSTRAINT `store's_deliveries_ibfk_1` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`),
  ADD CONSTRAINT `store's_deliveries_ibfk_2` FOREIGN KEY (`delivery_id`) REFERENCES `delivery` (`delivery_id`);

--
-- Constraints for table `store's_products`
--
ALTER TABLE `store's_products`
  ADD CONSTRAINT `store's_products_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`),
  ADD CONSTRAINT `store's_products_ibfk_2` FOREIGN KEY (`store_id`) REFERENCES `store` (`store_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
