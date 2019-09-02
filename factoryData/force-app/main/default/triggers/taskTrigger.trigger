trigger taskTrigger on task (before insert,after insert,before update, after update, before delete, after delete,after undelete) {
   Type t;
    if(trigger.isInsert){
        t = Type.forName(TriggerConstants.TaskInsert);
    } else if(trigger.isUpdate){
        t = Type.forName(TriggerConstants.TaskUpdate);
    } else if(trigger.isDelete){
        t = Type.forName(TriggerConstants.TaskDelete);
    } else if(trigger.isUnDelete){
        t = Type.forName(TriggerConstants.TaskUnDelete);
    }
    HandlerInterface v = (HandlerInterface)t.newInstance();
    v.ProcessData();
}