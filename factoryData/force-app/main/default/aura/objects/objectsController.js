({
    doInit : function(component, event, helper) {
        var action = component.get("c.getObjectNames");

        action.setCallback(this,function(response){
            component.set("v.objectNames",response.getReturnValue());
        });
    }
})
