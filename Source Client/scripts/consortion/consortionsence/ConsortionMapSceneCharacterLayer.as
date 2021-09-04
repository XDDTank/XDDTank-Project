package consortion.consortionsence
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.PathManager;
   import ddt.view.character.BaseLayer;
   
   public class ConsortionMapSceneCharacterLayer extends BaseLayer
   {
       
      
      private var _direction:int;
      
      private var _sex:Boolean;
      
      private var _playerInfo:PlayerInfo;
      
      public function ConsortionMapSceneCharacterLayer(param1:ItemTemplateInfo, param2:String = "", param3:int = 1, param4:Boolean = true)
      {
         this._direction = param3;
         this._sex = param4;
         super(param1,param2);
      }
      
      override protected function getUrl(param1:int) : String
      {
         var _loc2_:String = this._direction == 1 ? "cloth" : (this._direction == 2 ? "clothF" : "cloth");
         return PathManager.SITE_MAIN + "image/world/walkcloth/2/" + (!!this._sex ? "M" : "F") + "/" + _loc2_ + "/" + "default/" + String(param1) + ".png";
      }
   }
}
