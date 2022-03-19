// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cmodule.decry.Debuggee

package cmodule.decry
{
    public interface Debuggee 
    {

        function cancelDebug():void;
        function suspend():void;
        function resume():void;
        function get isRunning():Boolean;

    }
}//package cmodule.decry

