({
    doInit : function(component, event, helper) {
        var action = component.get("c.getObjectNames");
        action.setCallback(this,function(response){
            var values = response.getReturnValue()
            console.error("values: " + values);
            component.set("v.objectNames", values);
        });
        $A.enqueueAction(action);
        component.set('v.showLoading', false);
        $A.get('e.force:refreshView').fire();
    },

    configureObject : function(component, event, helper) {
        console.error("in here");
        var objectButton = event.getSource().get("v.label");
        alert(objectButton + " was pressed");
    },

    objectDetails : function(component, event, helper) {
        component.set("v.showIt", true);
        $A.get('e.force:refreshView').fire();
    },

    isRefreshed : function(component, event, helper) {

    }
})
