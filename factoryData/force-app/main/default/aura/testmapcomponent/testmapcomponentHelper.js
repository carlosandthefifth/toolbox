({
    getMap : function(component,event) {
        var action = component.get('c.returnMap');
        action.setCallback(this,function(response){
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.info("inside success");
                var mapValues = [];
                var values = response.getReturnValue();
                
                for (var key in values) {
                    console.info("values[key]: " + values[key]);
                    
                    mapValues.push({value:values[key], key:key});                
                }
                component.set("v.objectFields", mapValues);
            }
        });
        $A.enqueueAction(action); 
    }
})
