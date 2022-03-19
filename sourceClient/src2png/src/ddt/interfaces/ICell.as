// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.interfaces.ICell

package ddt.interfaces
{
    import flash.events.IEventDispatcher;
    import com.pickgliss.ui.core.ITipedDisplay;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.Sprite;

    public interface ICell extends IEventDispatcher, IDragable, IAcceptDrag, ITipedDisplay 
    {

        function set info(_arg_1:ItemTemplateInfo):void;
        function get info():ItemTemplateInfo;
        function getContent():Sprite;
        function dispose():void;
        function get locked():Boolean;
        function set locked(_arg_1:Boolean):void;

    }
}//package ddt.interfaces

