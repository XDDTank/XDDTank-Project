// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.IDisplayPack

package game.view
{
    import __AS3__.vec.Vector;
    import flash.display.DisplayObject;

    public interface IDisplayPack 
    {

        function get content():Vector.<DisplayObject>;
        function removeFromParent():void;
        function dispose():void;

    }
}//package game.view

