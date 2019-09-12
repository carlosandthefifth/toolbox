({
    doInit: function (component, event, helper) {
        var debugMode = component.get("v.debugModeOn");
        if (debugMode)
           console.info("inside doinit");

        var action = component.get("c.getObjectNames");
        var spinner = component.find("spinner");

        $A.util.toggleClass(spinner, "slds-hide"); // show loading spinner

        action.setCallback(this,function(response){

            var state = response.getState();
            
            if (state === "SUCCESS") {
                var returnValues = response.getReturnValue(); // get object names

                component.set("v.optionMap", returnValues);
                
                var optionValues = [];
                
                // Push the Map array into an unordered array for displaying
                for (var singlekey in returnValues) {
                    optionValues.push({label: singlekey + ":" + returnValues[singlekey], value: singlekey});
                }

                // Show the object names
                component.set("v.options", optionValues);
                // turn off loading spinner

                $A.util.toggleClass(spinner, "slds-hide");
                
                // set showloading to false so that other components show
                component.set("v.showLoading", false);
                // Are we in debug mode    
                
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

    cancel: function(component, event, helper) {
        // No changes made
        component.set("v.showEditRecordCount",false);
        $A.get("e.force:refreshView").fire();
    },

    changeRecordCount: function(component, event, helper) {
        // Switch to record count edit view
        component.set("v.showEditRecordCount", true);

        // Get the selected objects
        var selectedOptions = component.get("v.selectedOptions");
       
        // Load the map in question that holds values for each object in question
        var mapSelection = component.get("v.optionMap");
        
        var strArray = [];
        for (var i = 0 ; i < selectedOptions.length; i++) {       
            // Here we are pushing the object name and record count in map-like format.  This allows us to show the object name as a text field 
            // and the number of records as a number input field
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
        var debugMode = component.get("v.debugModeOn");     // show output to console if true
        var objects = component.get("v.selectedOptions");   // objects we selected
        var objectMap = component.get("v.optionMap");       // all objects in map array
        var objectMapLength = objects.length;               // How many objects were selected
        var recordObjectsCreated = [];                            // Store to later show user which objects were processed
        var firstPass = true;                               // flag
        var i = 0;                                          // index
        var action = component.get("c.createRecords");      // get server side method
        
        component.set("v.deletingData", false);

        if (debugMode)
            helper.debug_createData(objectMapLength, objects, recordObjectsCreated, i);

        action.setParams({objectName: objects[i], count : objectMap[objects[i]]}); // pass parameters to server side method

        action.setCallback(this, function(response) {
            var state = response.getState()
            if (state === "SUCCESS") {
                recordObjectsCreated.push(objects[i]);
                if (debugMode)
                    helper.debug_createData(objectMapLength, objects, recordObjectsCreated, i);

                component.set("v.objectsProcessed", recordObjectsCreated); // show how many objects were processed
                $A.get("e.force:refreshView").fire();              // Refresh
                
                i++
                if (i == objectMapLength) {
                    // All done
                    recordObjectsCreated.push("FINISHED CREATING ALL RECORDS");
                    component.set("v.objectsProcessed", recordObjectsCreated)
                    $A.get("e.force:refreshView").fire();
                    return;
                }

                action.setParams({objectName: objects[i], count : objectMap[objects[i]]});
                $A.enqueueAction(action);
            }
        });
        if (firstPass) {
            $A.enqueueAction(action);
            component.set("v.creatingData", true);
            firstPass=false;
        }
    },

    debug_createData: function(objectMapLength, objects, recordObjectsCreated, i)
    {
     
        console.log("objectMapLength: " + objectMapLength);
        console.log("objects: " + objects);
        console.log("objects[" + i + "]: " + objects[i]);
        console.log("objectMap[objects[0]]: " + objectMap[objects[i]]);

        console.log("recordObjectsCreated: " + JSON.stringify(recordObjectsCreated));

    },

    deleteData: function(component, event, helper) {
        var debugMode = component.get("v.debugModeOn");

        // Get the selected objects
        var objects = component.get("v.selectedOptions");
        // Get map that has the object name and the number of records
        // Number of records not important because we attempt to delete everything
        var objectMap = component.get("v.optionMap");
        var objectMapLength = objects.length;  // Have we reached the end of all the objects
        var objectRecordsDeleted = []; // Shows for which objects app attempted to delete records
        
        var firstPass = true;  // This is a function that is asynchronous that will call itself multiple times.  We need to know when the first call completed
        var i = 0;             // index
        var action = component.get("c.deleteRecords");  // grab server-sided method
        action.setParams({objectName: objects[i]});  // Pass the object name
        action.setCallback(this, function(response) {
            var state = response.getState()
            if (state === "SUCCESS") {
                // operation is complete
                var result = response.getReturnValue(); // function returns success or an error message 
                if (result == "SUCCESS") {
                    if (debugMode) // output to console
                       helper.debug_deleteData(objects,objectMap,objectMapLength,objectRecordsDeleted,i);

                    objectRecordsDeleted.push(objects[i]);  // Add object to completed list
                    component.set("v.objectsProcessed", objectRecordsDeleted); // show the list
                    $A.get("e.force:refreshView").fire(); // refresh the component
                    i++ // update the index
                    if (i == objectMapLength) {
                        // we have processed all objects
                        objectRecordsDeleted.push("FINISHED DELETING ALL RECORDS");
                        component.set("v.objectsProcessed", objectRecordsDeleted); // tell the user 
                        $A.get("e.force:refreshView").fire();
                        return; // exit loop
                    }

                    // Update parameters    
                    action.setParams({objectName: objects[i], count : objectMap[objects[i]]});
                    $A.enqueueAction(action); // call action again
                } // result == success
                else {
                    alert(result); // An error occurred.  Show user
                    return; // stop the process
                }
            }
        });

        if (firstPass) {
            // Calling action for first time
            $A.enqueueAction(action);
            component.set("v.deletingData", true);
            component.set("v.creatingData", false);
            firstPass=false;
        }
    },
    
    debug_deleteData:function(objects,objectMap,objectMapLength,objectRecordsDeleted,i) {
        console.log("objectMapLength: " + objectMapLength);
        console.log("objects: " + objects);
        console.log("objects[0]: " + objects[i]);
        console.log("objectMap[objects[0]]: " + objectMap[objects[i]]);
        console.log("creating: " + objects[i]);
        console.log("objectRecordsDeleted: " + JSON.stringify(objectRecordsDeleted));                
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
            optionValues.push({label: singlekey + ":" + optionMap[singlekey], value: singlekey}); // label format object:record count eg., Account:10
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

    getAllowedObjects: function(component, event, helper) {
        var button = component.find("allowedObjectsButton");
        var showAllowed = component.get("v.showAllowedObjects");
        if (showAllowed) {
            component.set("v.showAllowedObjects", false);
            button.set("v.label", "Show Allowed Objects");
            showAllowed = false;
            $A.get("e.force:refreshView").fire();
        } else 
        {
            component.set("v.showAllowedObjects", true);
            button.set("v.label", "Hide Allowed Objects");
            showAllowed = true;
        }

        component.set("v.showAllowedObjects", showAllowed);

        if (showAllowed) {
            var action = component.get("c.showAllowedObjects");
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set("v.allowedObjects", response.getReturnValue());
                    $A.get("e.force:refreshView").fire();
                }
            });
            $A.enqueueAction(action);
        }
    },

    getUnsupportedObjects: function(component, event, helper) {
        var button = component.find("unsupportedObjectsButton");
        var showUnsupportedObjects = component.get("v.showUnsupportedObjects");
        if (showUnsupportedObjects) {
            component.set("v.showUnsupportedObjects", false);
            button.set("v.label", "Show Unsupported Objects");
            showUnsupportedObjects = false;
            $A.get("e.force:refreshView").fire();
        } else 
        {
            component.set("v.showUnsupportedObjects", true);
            button.set("v.label", "Hide Unsupported Objects");
            showUnsupportedObjects = true;
        }

        component.set("v.showUnsupportedObjects", showUnsupportedObjects);

        if (showUnsupportedObjects) {
            var action = component.get("c.showUnsupportedObjects");
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set("v.unsupportedObjects", response.getReturnValue());
                    $A.get("e.force:refreshView").fire();
                }
            });
            $A.enqueueAction(action);
        }
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