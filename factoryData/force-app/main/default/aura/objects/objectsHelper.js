({
    init : function(component) {
        var spinner = component.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");

        // connect to the server-sided controller
        var actionNames = component.get("c.getObjectNames");
        // We need to add additional information to be displayed
        var transformedData = [];
        actionNames.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                // get the array of values
                var values = response.getReturnValue()
                console.error("values: " + values);
                // add record count 
                for (var i = 0; i < values.length; i++) {
                    transformedData.push(values[i]);
                    transformedData.push("0"); // hard coded -- change
                }

                component.set("v.objectNames", transformedData); // set the view list
                component.set("v.showLoading", false); // turn off show loading to show the view list
                $A.util.toggleClass(spinner, "slds-hide");
                $A.get('e.force:refreshView').fire(); // refresh the component
            } 
            else if (state === "INCOMPLETE") {

            } else if (state === "ERROR") {

            }            
        });
        $A.enqueueAction(actionNames);    
    },

    getObjectDetail: function(component,event) {
        // which button was clicked 
        var strArry = component.get("v.objectNames");
        var whichOne = event.getSource().get("v.name");
        var objectName = strArry[whichOne];
        console.info("objectName: " + objectName);
        var actionFields = component.get("c.getFields");
        actionFields.setParams({objectName : objectName});

        actionFields.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("response.getReturnValue(): " + response.getReturnValue());
                var values =  response.getReturnValue();
                var transformedData = [];
                for (var i = 0; i < values.length; i++) {
                    transformedData.push(values[i]);
                    console.info("values[" + i + "]: " + values[i]);
                }
                component.set("v.fields", transformedData);

                component.set("v.buttonIndex", whichOne + 1);
                component.set("v.showIt",true);
                component.set("v.objectDetailName", event.getSource().get("v.label"));
                component.set("v.recordCount", strArry[whichOne + 1]);
                $A.get('e.force:refreshView').fire();
        
            }
        });
        $A.enqueueAction(actionFields);    
    },

    getObjectList: function(component) {
        component.set("v.showIt",false);
        $A.get('e.force:refreshView').fire();    
    },

    save: function(component, event) {
        var whichObject = component.get("v.recordCount");
        var whichOne = event.getSource().get("v.name");
        console.error(whichOne);
        var strArry = component.get("v.objectNames");
        // validation check
        component.find("recordInput");

        console.warn("strArray[" + whichOne + "]: " + strArry[whichOne]);
        console.error("component.find(recordInput).get(v.value): " + component.find("recordInput").get("v.value"));
        strArry[whichOne] = component.find("recordInput").get("v.value");
        console.info("2 strArry[" + whichOne + "]: " + strArry[whichOne]);
        component.set("v.objectNames", strArry);
        component.set("v.showIt",false);
        $A.get('e.force:refreshView').fire();    
    }
})
