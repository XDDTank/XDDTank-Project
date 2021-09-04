package consortion
{
   import church.vo.SceneMapVO;
   import ddt.view.sceneCharacter.SceneCharacterEvent;
   import flash.geom.Point;
   
   public interface IConsortionState
   {
       
      
      function addSelfPlayer() : void;
      
      function get sceneMapVO() : SceneMapVO;
      
      function set sceneMapVO(param1:SceneMapVO) : void;
      
      function setCenter(param1:SceneCharacterEvent = null) : void;
      
      function movePlayer(param1:int, param2:Array) : void;
      
      function updatePlayerStauts(param1:int, param2:int, param3:Point) : void;
      
      function updateSelfStatus(param1:int) : void;
   }
}
