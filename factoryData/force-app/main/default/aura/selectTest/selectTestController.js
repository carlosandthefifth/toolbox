({
    doInit: function (component, event, helper) {
        helper.doInit(component,event);
    },

    cancel: function(component, event, helper) {

    },

    changeRecordCount: function(component, event, helper) {
        helper.changeRecordCount(component,event);
    },

    createData: function(component, event, helper) {

    },

    doRefresh: function(component, event, helper) {

    },

    save: function(component, event, helper) {
        helper.save(component,event);
    },
    


    onSelection: function(component, event, helper) {
        helper.onClick(component,event,helper);
    }
});