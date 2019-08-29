({
    doInit : function(component, event, helper) {
        var action = component.get("c.getObjectNames");

        action.setCallback(this,function(response){
            var values = response.getReturnValue()
            console.error("values: " + values);
            component.set("v.objectNames", values);
        });
        $A.enqueueAction(action);
    }
})
