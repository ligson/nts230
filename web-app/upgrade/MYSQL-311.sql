-- program
 -- alter table program add category int not null default 0;
 -- alter table program add eidtion int not null default 0;
 -- alter table program add other_option int not null default 0;
 -- alter table program add out_class_id int not null default 0;
 update program set can_distribute = 0 where can_distribute is null;
 update program set pre_version = -1 where pre_version is null;
 update program set from_state = 0 where from_state is null;
 update program set from_node_id = 0 where from_node_id is null;
 update program set now_version = 0 where now_version is null;
 update program set category = 0 where category is null;
 update program set eidtion = 0 where eidtion is null;
 update program set other_option = 0 where other_option is null;
 update program set out_class_id = 0 where out_class_id is null;
 -- update program set limit_range = 2 where limit_range is null;
 update program set can_union = 0 where can_union is null;
 update program set can_public = 0 where can_public is null;
