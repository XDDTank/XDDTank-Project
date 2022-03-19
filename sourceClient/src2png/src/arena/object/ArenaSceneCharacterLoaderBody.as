// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.object.ArenaSceneCharacterLoaderBody

package arena.object
{
    import ddt.view.sceneCharacter.SceneCharacterLoaderBody;
    import ddt.data.player.PlayerInfo;
    import ddt.view.sceneCharacter.SceneCharacterLayer;
    import ddt.manager.ItemManager;
    import __AS3__.vec.*;

    public class ArenaSceneCharacterLoaderBody extends SceneCharacterLoaderBody 
    {

        private var _playerType:int;

        public function ArenaSceneCharacterLoaderBody(_arg_1:PlayerInfo, _arg_2:int)
        {
            super(_arg_1);
            this._playerType = _arg_2;
        }

        override protected function initLoaders():void
        {
            _loaders = new Vector.<SceneCharacterLayer>();
            _recordStyle = _playerInfo.Style.split(",");
            _recordColor = _playerInfo.Colors.split(",");
            _loaders.push(new ArenaSceneCharacterLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[0].split("|")[0])), _recordColor[0], 1, _playerInfo.Sex, this._playerType));
            _loaders.push(new ArenaSceneCharacterLayer(ItemManager.Instance.getTemplateById(int(_recordStyle[0].split("|")[0])), _recordColor[0], 2, _playerInfo.Sex, this._playerType));
        }

        public function get playerType():int
        {
            return (this._playerType);
        }


    }
}//package arena.object

