// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.states.IStateCreator

package ddt.states
{
    public interface IStateCreator 
    {

        function create(_arg_1:String):BaseStateView;
        function createAsync(_arg_1:String, _arg_2:Function, _arg_3:Boolean=false):void;

    }
}//package ddt.states

