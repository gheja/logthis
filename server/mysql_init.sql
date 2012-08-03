CREATE TABLE IF NOT EXISTS `entry` (
  `entry_id` int(10) unsigned NOT NULL auto_increment,
  `user_id` int(10) unsigned NOT NULL COMMENT '->user.user_id',
  `uuid` char(22) NOT NULL,
  `timestamp` int(11) NOT NULL,
  `data` blob NOT NULL,
  PRIMARY KEY  (`entry_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

CREATE TABLE IF NOT EXISTS `user` (
  `user_id` int(11) NOT NULL auto_increment,
  `username` char(32) NOT NULL,
  `password` char(32) default NULL,
  `logkey` char(32) NOT NULL,
  `logsecret` char(32) NOT NULL,
  `adminkey` char(32) NOT NULL,
  `adminsecret` char(32) NOT NULL,
  `status` enum('pending','enabled','disabled') NOT NULL default 'pending',
  PRIMARY KEY  (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `logkey` (`logkey`),
  UNIQUE KEY `logsecret` (`logsecret`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;
