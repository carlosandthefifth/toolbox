public class CustomerImplInvocationClass {

    public static void invokeCustomImpl() {
        // Get the class name from a custom setting.
        // This class implements the Vehicle interface.
        CustomImplementation__c cs = CustomImplementation__c.getInstance('Vehicle');
        
        // Get the Type corresponding to the class name
        Type t = Type.forName(cs.className__c);
        
        // Instantiate the type.
        // The type of the instantiated object 
        //   is the interface.
        Vehicle v = (Vehicle)t.newInstance();
        
        // Call the methods that have a custom implementation
        System.debug('Max speed: ' + v.getMaxSpeed());
        System.debug('Vehicle type: ' + v.getType());       
    }
}