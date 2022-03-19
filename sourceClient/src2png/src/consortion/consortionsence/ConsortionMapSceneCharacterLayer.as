// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.consortionsence.ConsortionMapSceneCharacterLayer

package consortion.consortionsence
{
    import ddt.view.character.BaseLayer;
    import ddt.data.player.PlayerInfo;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PathManager;

    public class ConsortionMapSceneCharacterLayer extends BaseLayer 
    {

        private var _direction:int;
        private var _sex:Boolean;
        private var _playerInfo:PlayerInfo;

        public function ConsortionMapSceneCharacterLayer(_arg_1:ItemTemplateInfo, _arg_2:String="", _arg_3:int=1, _arg_4:Boolean=true)
        {
            this._direction = _arg_3;
            this._sex = _arg_4;
            super(_arg_1, _arg_2);
        }

        override protected function getUrl(_arg_1:int):String
        {
            var _local_2:String = ((this._direction == 1) ? "cloth" : ((this._direction == 2) ? "clothF" : "cloth"));
            return ((((((((PathManager.SITE_MAIN + "image/world/walkcloth/2/") + ((this._sex) ? "M" : "F")) + "/") + _local_2) + "/") + "default/") + String(_arg_1)) + ".png");
        }


    }
}//package consortion.consortionsence

