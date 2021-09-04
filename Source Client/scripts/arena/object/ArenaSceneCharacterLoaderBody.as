package arena.object
{
   import ddt.data.player.PlayerInfo;
   import ddt.manager.ItemManager;
   import ddt.view.sceneCharacter.SceneCharacterLayer;
   import ddt.view.sceneCharacter.SceneCharacterLoaderBody;
   
   public class ArenaSceneCharacterLoaderBody extends SceneCharacterLoaderBody
   {
       
      
      private var _playerType:int;
      
      public function ArenaSceneCharacterLoaderBody(param1:PlayerInfo, param2:int)
      {
         super(param1);
         this._playerType = param2;
      }
      
      override protected function initLoaders() : void
      {
         _loaders = new Vector.<SceneCharacterLayer>();
         _recordStyle = _playerInfo.Style.split(",");
         _recordColor = _playerInfo.Colors.split(",");
         _loaders.push(new ArenaSceneCharacterLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[0].split("|")[0])),_recordColor[0],1,_playerInfo.Sex,this._playerType));
         _loaders.push(new ArenaSceneCharacterLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[0].split("|")[0])),_recordColor[0],2,_playerInfo.Sex,this._playerType));
      }
      
      public function get playerType() : int
      {
         return this._playerType;
      }
   }
}
