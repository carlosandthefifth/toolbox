({
    doInit: function (component, event, helper) {
        console.info("inside doinit");
        var action = component.get("c.discoverObjects");

        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.error("response.getReturnValue(): " +  response.getReturnValue());
                var returnValues = response.getReturnValue();
                component.set("v.optionMap", returnValues);
                console.log("returnValues: " + returnValues);
                var optionValues = [];
                for (var singlekey in returnValues) {
                    optionValues.push({label: singlekey + ":" + returnValues[singlekey], value: singlekey});
                }
                console.log("optionValues: " + optionValues);
                component.set("v.options", optionValues);
                
            }
        });
        $A.enqueueAction(action);
    },

    cancel: function(component, event, helper) {

    },

    changeRecordCount: function(component, event, helper) {
        component.set("v.showEditRecordCount", true);
        var selectedOptions = component.get("v.selectedOptions");
        console.warn("options2: " + selectedOptions);

        var mapSelection = component.get("v.optionMap");
        console.error("mapSelection: " + JSON.stringify(mapSelection));
        var strArray = [];
        for (var i = 0 ; i < selectedOptions.length; i++) {
            console.log("selectedOptions[i]: " + selectedOptions[i]);
            strArray.push(selectedOptions[i]);
            strArray.push(mapSelection[selectedOptions[i]]);
        }

        for (var i = 0; i < strArray.length; i++) {
            console.log("&&& strArray: " + strArray[i]);
        }
        console.log("StrArray: " + strArray);
        component.set("v.objectRecords", strArray);
    },

    doRefresh: function(component, event, helper) {

    },

    save: function(component, event, helper) {
        var myInputs = component.find("myDiv").find({instancesOf : "lightning:input"});
        alert("There are " + myInputs.length + " lightning:input elements within myDiv.");

        var optionsSelected = component.get('v.selectedOptions');
        var optionMap = component.get("v.optionMap");
        for(var i = 0; i < myInputs.length; i++) {
            console.log("i: " + i);
            console.log("------> aura element in array value @ index " + i + " = " + myInputs[i].get("v.value"));
            console.log("------> aura element in array name @ index " + i + " = " + myInputs[i].get("v.name"));
            console.log("optionsSelected[" + i + "]: " + optionsSelected[i]);
            console.log("optionMap[optionsSelected[i]]: " + optionMap[optionsSelected[i]]);
            optionMap[optionsSelected[i]] = myInputs[i].get("v.value");
        }
        
        

        
        console.log("optionMap: " + JSON.stringify(optionMap));
        var optionValues = [];
        for (var singlekey in optionMap) {
            optionValues.push({label: singlekey + ":" + optionMap[singlekey], value: singlekey});
        }
        console.log("optionValues: " + optionValues);
        component.set("v.options", optionValues);
        component.set("v.showEditRecordCount",false);
        $A.get("e.force:refreshView").fire();
    },
    


    onClick: function(component, event, helper) {
        var whodis = event.getSource().getLocalId();
        console.info("whodis: " + whodis);
        var selectedOptionsList = event.getParam("value");
        component.set("v.selectedOptions", selectedOptionsList);
        console.info("selectedOptionsList: " + selectedOptionsList);
        console.info("selectedOptionsList.length: " + selectedOptionsList.length);
        if ((selectedOptionsList.length > 0))
            component.set("v.showChangeRecordButton", true)
        else    
            component.set("v.showChangeRecordButton", false)
        $A.get("e.force:refreshView").fire();
    }
});