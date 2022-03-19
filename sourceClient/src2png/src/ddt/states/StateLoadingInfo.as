// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.states.StateLoadingInfo

package ddt.states
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import __AS3__.vec.*;

    public class StateLoadingInfo 
    {

        public var neededUIModule:Vector.<String> = new Vector.<String>();
        public var callBack:Function;
        public var progress:Dictionary = new Dictionary();
        public var isComplete:Boolean;
        public var isLoading:Boolean;
        public var completeedUIModule:Vector.<String> = new Vector.<String>();
        public var state:String;


    }
}//package ddt.states

