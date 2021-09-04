package arena.object
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.PathManager;
   import ddt.view.sceneCharacter.SceneCharacterLayer;
   
   public class ArenaSceneCharacterLayer extends SceneCharacterLayer
   {
       
      
      private var _playerType:int;
      
      public function ArenaSceneCharacterLayer(param1:ItemTemplateInfo, param2:String = "", param3:int = 1, param4:Boolean = true, param5:int = 0)
      {
         this._playerType = param5;
         super(param1,param2,param3,param4);
      }
      
      override protected function getUrl(param1:int) : String
      {
         var _loc2_:String = _direction == 1 ? "cloth" : (_direction == 2 ? "clothF" : "cloth");
         var _loc3_:String = this._playerType == 0 ? "cloth1" : "cloth2";
         return PathManager.SITE_MAIN + "image/world/walkcloth/3/" + (!!_sex ? "M" : "F") + "/" + _loc2_ + "/" + _loc3_ + "/" + String(param1) + ".png";
      }
   }
}
