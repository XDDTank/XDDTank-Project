// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.IConsortionState

package consortion
{
    import church.vo.SceneMapVO;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import flash.geom.Point;

    public interface IConsortionState 
    {

        function addSelfPlayer():void;
        function get sceneMapVO():SceneMapVO;
        function set sceneMapVO(_arg_1:SceneMapVO):void;
        function setCenter(_arg_1:SceneCharacterEvent=null):void;
        function movePlayer(_arg_1:int, _arg_2:Array):void;
        function updatePlayerStauts(_arg_1:int, _arg_2:int, _arg_3:Point):void;
        function updateSelfStatus(_arg_1:int):void;

    }
}//package consortion

