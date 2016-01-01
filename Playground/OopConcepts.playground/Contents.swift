/*Objects and Classes*/

class VolumeConsumed{

    
    
//class variables
    var glassCount = 0
    var glassVolume = 0
    
    //Default Constructor :- Called as Inititalizer in Swift
    init(glassCount:Int, glassVolume: Int)
    {
        self.glassCount = glassCount  //Similar to this keyword in Java
        self.glassVolume = glassVolume
        
    }
   func CalculateTotalVolume( ) ->Int
   {
    var result = glassCount * glassVolume
    return result
    
    }
}



//Create an Instance
var calc = VolumeConsumed(glassCount: 1,glassVolume: 1);
//calc.glassCount = 10
//calc.glassVolume = 5
calc.CalculateTotalVolume()

