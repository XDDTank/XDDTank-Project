// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.character.ICharacter

package ddt.view.character
{
    import flash.display.IDisplayObject;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.data.player.PlayerInfo;
    import flash.geom.Point;

    public interface ICharacter extends IColorEditable, IDisplayObject, Disposeable 
    {

        function get info():PlayerInfo;
        function get currentFrame():int;
        function doAction(_arg_1:*):void;
        function actionPlaying():Boolean;
        function show(_arg_1:Boolean=true, _arg_2:int=1, _arg_3:Boolean=true):void;
        function setFactory(_arg_1:ICharacterLoaderFactory):void;
        function set smoothing(_arg_1:Boolean):void;
        function set showGun(_arg_1:Boolean):void;
        function setShowLight(_arg_1:Boolean, _arg_2:Point=null):void;
        function drawFrame(_arg_1:int, _arg_2:int=0, _arg_3:Boolean=true):void;
        function get currentAction():*;
        function get characterWidth():Number;
        function get characterHeight():Number;
        function get completed():Boolean;
        function setDefaultAction(_arg_1:*):void;

    }
}//package ddt.view.character

