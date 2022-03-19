// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.ILayer

package ddt.view.character
{
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.DisplayObject;

    public interface ILayer extends IColorEditable 
    {

        function get info():ItemTemplateInfo;
        function set info(_arg_1:ItemTemplateInfo):void;
        function getContent():DisplayObject;
        function dispose():void;
        function load(_arg_1:Function):void;
        function set currentEdit(_arg_1:int):void;
        function get currentEdit():int;
        function get width():Number;
        function get height():Number;
        function get isComplete():Boolean;

    }
}//package ddt.view.character

