({
    doInit: function (component, event, helper) {
        console.info("inside doinit");
        var action = component.get("c.discoverObjects");

        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                console.error("response.getReturnValue(): " +  response.getReturnValue());
                var returnValues = response.getReturnValue();
                var optionValues = [];
                for (var i = 0; i < returnValues.length; i++) {
                    optionValues.push({value: returnValues[i], label: returnValues[i]});
                }
                component.set("v.options", optionValues);
            
            }
        });
        $A.enqueueAction(action);
    },

    cancel: function(component, event, helper) {

    },

    changeRecordCount: function(component, event, helper) {
        component.set("v.showRecordsSelected", true);
        var selectedOptions = component.get("v.selectedOptions");
        for (var i = 0; i < selectedOptions.length; i++) {
            console.error(":selectedOptionsList[i].split(:) " + selectedOptions[i].split(":"));
            var splitter = selectedOptions[i].split(":");
            console.error("splitter: " + splitter);
        }

        console.error("splitter1: " + splitter[0]);
        console.error("splitter2: " + splitter[1]);
        component.set("v.objectRecords",splitter);
    },

    doRefresh: function(component, event, helper) {

    },

    save: function(component, event, helper) {
        var nameIs = event.getSource().get("v.name");
 //       console.error("nameIs: " + nameIs);
        nameIs = event.getSource().get("v.value");
   //     console.error("valueIs: " + nameIs);
        nameIs = event.getSource().get("v.label");
        console.error("labelIs: " + nameIs);


        var editor = component.find("recordInput").get("v.name");
        console.error("editor: " + editor);
        var value = component.find("recordInput").get("v.value");
        console.error("value is: " + value);
        value = component.find("recordInput").get("v.name");
        console.error("name is: " + value);
        
        var number = integer.valueof(value);
        console.error("number: " + number);
        var options = component.get("v.selectedOptions");
        console.error("options: " + options);
        var split = options[integer.valueof(value) - 1].split(":");
        console.error("split: " + split);
        
    },

    onClick: function(component, event, helper) {
        var whodis = event.getSource().getLocalId();
        console.info("whodis: " + whodis);
        var selectedOptionsList = event.getParam("value");
        component.set("v.selectedOptions", selectedOptionsList);
        console.info("selectedOptionsList: " + selectedOptionsList);
        console.info("selectedOptionsList.length: " + selectedOptionsList.length);
        if ((selectedOptionsList.length > 0))
            component.set("v.recordsSelected", true)
        else    
            component.set("v.recordsSelected", false)
        $A.get("e.force:refreshView").fire();
    }
});