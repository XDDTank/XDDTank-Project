// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.interfaces.IProcessObject

package ddt.interfaces
{
    import com.pickgliss.ui.core.Disposeable;

    public interface IProcessObject extends Disposeable 
    {

        function get onProcess():Boolean;
        function set onProcess(_arg_1:Boolean):void;
        function process(_arg_1:Number):void;

    }
}//package ddt.interfaces

