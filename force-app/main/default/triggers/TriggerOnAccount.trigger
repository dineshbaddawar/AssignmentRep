trigger TriggerOnAccount on Account (After insert) {
    
    if(trigger.isAfter && trigger.isInsert){
        AccountDefaultActiveContactCreation.createContactWhenAccountisActive(trigger.new);
    }
}