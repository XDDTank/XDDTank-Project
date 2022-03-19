// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.ICharacterLoader

package ddt.view.character
{
    public interface ICharacterLoader 
    {

        function setFactory(_arg_1:ILayerFactory):void;
        function getContent():Array;
        function load(_arg_1:Function=null):void;
        function update():void;
        function dispose():void;

    }
}//package ddt.view.character

