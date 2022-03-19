// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.object.ArenaSceneCharacterLayer

package arena.object
{
    import ddt.view.sceneCharacter.SceneCharacterLayer;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PathManager;

    public class ArenaSceneCharacterLayer extends SceneCharacterLayer 
    {

        private var _playerType:int;

        public function ArenaSceneCharacterLayer(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:int=1, _arg_4:Boolean=true, _arg_5:int=0)
        {
            this._playerType = _arg_5;
            super(_arg_1, _arg_2, _arg_3, _arg_4);
        }

        override protected function getUrl(_arg_1:int):String
        {
            var _local_2:String = ((_direction == 1) ? "cloth" : ((_direction == 2) ? "clothF" : "cloth"));
            var _local_3:String = ((this._playerType == 0) ? "cloth1" : "cloth2");
            return (((((((((PathManager.SITE_MAIN + "image/world/walkcloth/3/") + ((_sex) ? "M" : "F")) + "/") + _local_2) + "/") + _local_3) + "/") + String(_arg_1)) + ".png");
        }


    }
}//package arena.object

