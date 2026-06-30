select * from `endorsement_details`
 where `push_ckyc_to_sftp`.`endt_id` = `endorsement_details`.`id` 
 and 

exists 
 
 (select * from `endorsement_ckyc_details` 
 where `endorsement_details`.`id` = `endorsement_ckyc_details`.`endorsement_detail_id` 
 and `scheduled_job_for_metadata_push` is null)) 
 or exists (select * from `proposal_details`
 where `push_ckyc_to_sftp`.`proposal_id` = `proposal_details`.`id` and 
 exists (select * from `proposal_ckyc_details` where `proposal_details`.`id` = `proposal_ckyc_details`.`proposal_detail_id` 
 and `ckyc_verified_via` is not null and `ckyc_verification_flag` is not null))) 
 and `is_metadoc_pushed` = ? and `meta_doc_attempts` = ? limit ?
 
''' 
SR139620


#https://github.com/darshandesai1095/reat-time-chat-app/tree/main/server

#https://github.com/Aarthi1720/Smart_Expense_Tracker/tree/main

#https://github.com/sharmaHarshit2000/expense-tracker

'''
