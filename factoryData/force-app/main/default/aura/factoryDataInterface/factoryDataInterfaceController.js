({
    doInit: function (component, event, helper) {
        var rendered = component.get("v.isDoneRendering");
        console.log("rendered: " + rendered);
        if (rendered == false)
            helper.doInit(component,event, helper);
    },

    cancel: function(component, event, helper) {
        helper.cancel(component, event, helper);
    },

    changeRecordCount: function(component, event, helper) {
        helper.changeRecordCount(component,event,helper);
    },

    deleteData: function(component, event, helper) {
        helper.deleteData(component, event, helper);
    },

    createData: function(component, event, helper) {
        helper.createData(component, event, helper);
    },

    doRefresh: function(component, event, helper) {

    },

    getAllowedObjects: function(component, event, helper) {
        helper.getAllowedObjects(component, event, helper);
    },

    getUnsupportedObjects: function(component, event, helper) {
        helper.getUnsupportedObjects(component, event, helper);
    },

    save: function(component, event, helper) {
        helper.save(component,event, helper);
    },
    
    showToast: function(component, event, helper) {
        helper.showToast(component, event, helper);
    },

    onSelection: function(component, event, helper) {
        helper.onSelection(component,event,helper);
    },

    doneRendering: function(cmp, event, helper) {
        console.log("inside doneRendering");
        if(!cmp.get("v.isDoneRendering")){
          cmp.set("v.isDoneRendering", true);
          console.log("done rendering");
          //do something after component is first rendered
        }
        console.log("donerendering: " + cmp.get("v.isDoneRendering"));
      }
});