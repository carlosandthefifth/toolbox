({
    doInit: function (component, event, helper) {
        console.info("inside doinit");
        var action = component.get("c.getObjectNames");
        var spinner = component.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide"); // show it

        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnValues = response.getReturnValue();
                component.set("v.optionMap", returnValues);
                var optionValues = [];
                for (var singlekey in returnValues) {
                    optionValues.push({label: singlekey + ":" + returnValues[singlekey], value: singlekey});
                }
                component.set("v.options", optionValues);
                $A.util.toggleClass(spinner, "slds-hide");
                component.set("v.showLoading", false);
                // Are we in debug mode    
                var debugMode = component.get("v.debugModeOn");
                if (debugMode) // output to console
                    helper.debug_doInit(returnValues, optionValues);
            }
        });
        $A.enqueueAction(action);
    },

    debug_doInit: function(returnValues, optionValues) {
        console.log("returnValues: " + returnValues);
        console.log("optionValues: " + optionValues);
    },

    cancel: function(component, event) {

    },

    changeRecordCount: function(component, event, helper) {
        component.set("v.showEditRecordCount", true);
        var selectedOptions = component.get("v.selectedOptions");
       

        var mapSelection = component.get("v.optionMap");
        
        var strArray = [];
        for (var i = 0 ; i < selectedOptions.length; i++) {       
            strArray.push(selectedOptions[i]);
            strArray.push(mapSelection[selectedOptions[i]]);
        }

        component.set("v.objectRecords", strArray);
        var debugMode = component.get("v.debugModeOn");
        if (debugMode) // output to console
            helper.debug_changeRecordCount(selectedOptions, mapSelection, strArray);
    },

    debug_changeRecordCount: function(selectedOptions, mapSelection, strArray) {
        console.warn("options2: " + selectedOptions);
        console.error("mapSelection: " + JSON.stringify(mapSelection));
        console.log("selectedOptions[i]: " + selectedOptions[i]);
        for (var i = 0; i < strArray.length; i++) {
            console.log("&&& strArray: " + strArray[i]);
        }
        console.log("StrArray: " + strArray);
    },

    createData: function(component, event, helper) {
        var objects = component.get("v.selectedOptions");
        var objectMap = component.get("v.optionMap");
        var objectMapLength = objects.length;
        var recordsCreated = component.get("v.recordsCreated");
        console.log("objectMapLength: " + objectMapLength);
        var firstPass = true;
        var i = 0;
        console.log("objects: " + objects);
        console.log("objects[0]: " + objects[i]);
        console.log("objectMap[objects[0]]: " + objectMap[objects[i]]);
        var action = component.get("c.createRecords");

        action.setParams({objectName: objects[i], count : objectMap[objects[i]]});

        action.setCallback(this, function(response) {
            var state = response.getState()
            if (i == objectMapLength)
                alert("Records created")
            else {
                recordsCreated.push(objectMap[objects[i]);
                
                component.set("v.recordsCreated")
                i++
                if (i == objectMapLength) {
                    alert("Records created");
                    return;
                }

                action.setParams({objectName: objects[i], count : objectMap[objects[i]]});
                $A.enqueueAction(action);
            }
        });
        if (firstPass) {
            $A.enqueueAction(action);
            firstPass=false;
        }
    },
    
    doRefresh: function(component, event) {

    },

    save: function(component, event, helper) {
        // Get the number of instances of Lighting:Inputs in this div
        var myInputs = component.find("myDiv").find({instancesOf : "lightning:input"});
        var optionsSelected = component.get('v.selectedOptions'); // Get the objects and new record count
        var optionMap = component.get("v.optionMap"); // Get the map that contains all objects and record count
        
        var debugMode = component.get("v.debugModeOn");
        // Are we in debug mode?
        for(var i = 0; i < myInputs.length; i++) {
    
            optionMap[optionsSelected[i]] = myInputs[i].get("v.value");
        }
        
        var optionValues = [];
        for (var singlekey in optionMap) {
            optionValues.push({label: singlekey + ":" + optionMap[singlekey], value: singlekey});
        }
        
        component.set("v.options", optionValues);
        component.set("v.showEditRecordCount",false);
        $A.get("e.force:refreshView").fire();

        if (debugMode) // output to console
            helper.debug_save(myInputs,optionsSelected,optionMap,optionValues);
    },
    
    debug_save: function(myInputs,optionsSelected,optionMap,optionValues) {
        alert("There are " + myInputs.length + " lightning:input elements within myDiv.");
        for(var i = 0; i < myInputs.length; i++) {
            console.log("i: " + i);
            console.log("------> aura element in array value @ index " + i + " = " + myInputs[i].get("v.value"));
            console.log("------> aura element in array name @ index " + i + " = " + myInputs[i].get("v.name"));
            console.log("optionsSelected[" + i + "]: " + optionsSelected[i]);
            console.log("optionMap[optionsSelected[i]]: " + optionMap[optionsSelected[i]]);
        }
        console.log("optionMap: " + JSON.stringify(optionMap));
        console.log("optionValues: " + optionValues);
    },

    onSelection: function(component, event, helper) {

        var selectedOptionsList = event.getParam("value"); // What have we selected if anything

        component.set("v.selectedOptions", selectedOptionsList); // Add the selected item to the select options list
        
        // Do we have items selected
        if ((selectedOptionsList.length > 0))
            component.set("v.showChangeRecordButton", true) // show the button that allows updating the record count
        else    
            component.set("v.showChangeRecordButton", false) // hide the button that allows updating the record count
        // Refresh page    
        $A.get("e.force:refreshView").fire();

        // Are we in debug mode    
        var debugMode = component.get("v.debugModeOn");
        if (debugMode) // output to console
            helper.debug_onSelection(event,selectedOptionsList);
    },

    debug_onSelection: function(event,selectedOptionsList) {
        var whodis = event.getSource().getLocalId();
        console.info("whodis: " + whodis);
        console.info("selectedOptionsList: " + selectedOptionsList);
        console.info("selectedOptionsList.length: " + selectedOptionsList.length);
    }
})
