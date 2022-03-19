// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.interfaces.ICommandedAble

package game.interfaces
{
    import flash.utils.Dictionary;

    public interface ICommandedAble 
    {

        function get commandList():Dictionary;
        function initCommand():void;
        function command(_arg_1:String, _arg_2:*):Boolean;

    }
}//package game.interfaces

